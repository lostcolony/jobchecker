defmodule Orchestration do

  def run() do
    Application.fetch_env!(:jobchecker, :file)
    |> run
  end

  def run(file) do
    lookup = file |> load_jobs |> fan_out

    count = map_size(lookup)

    jobs = listen(lookup, count, %{})

    new_jobs = get_new_jobs(jobs)
    email_new_jobs(new_jobs)
    Process.sleep(60*60*1000)
    run(file)
  end

  def load_jobs(file) do
    elem(Code.eval_file(file), 0)
  end

  def spin_up_checker(job_tuple) do
    spawn_link(Jobchecker, :init, [job_tuple, self()])
  end

  def fan_out(jobs) do
    Process.flag(:trap_exit, true)

    Enum.map(jobs, fn job -> {elem(job, 0), spin_up_checker(job)} end)
    |> Enum.reduce(%{}, fn ({company, reference}, map) -> Map.put_new(map, reference, company) end)
  end

  def get_new_jobs(scraped_jobs) do
    for {company, jobs} <- scraped_jobs do
      if is_list(jobs) && jobs != [] do
        previous_jobs = Persistence.retrieve_jobs(company)
        new_jobs =
          if previous_jobs != nil do
            jobs -- previous_jobs.jobs
          else
            jobs
          end
        Persistence.insert_jobs(company, jobs)
        {company, new_jobs}
      end
    end
  end


  def listen(_, 0, acc), do: acc
  def listen(map, count, acc) do
    {count, acc} =
      receive do
        {:EXIT, _, :normal} -> {count - 1, acc}
        {:EXIT, pid, failure} -> {count - 1, Map.put(acc, Map.get(map, pid), failure)}
        {company, jobs} -> {count, Map.put(acc, company, jobs)}
      end
    listen(map, count, acc)
  end


  def email_new_jobs(jobs) do
    IO.inspect(jobs)
    body = Enum.map(jobs, fn ({company, job_list}) ->
      if job_list == [] do
        ""
      else
        company <> ":\r\n\t" <>
        (Enum.map(job_list, fn ({title, url}) -> title <> ": " <> url end) |> Enum.join("\r\n\t")) <> "\r\n\r\n"
      end
    end) |> Enum.join()
    case String.length(body) do
      0 -> :ok
      _ -> send_email(body)
    end
  end



  def send_email(body) do
    email = {Application.get_env(:jobchecker, :from), [Application.get_env(:jobchecker, :to)],
    'Subject: Jobcheck Jobs\r\nFrom: Jobchecker <#{Application.get_env(:jobchecker, :from)}>\r\nTo: You\r\n\r\n#{body}'}

    options = [{:relay, Application.get_env(:jobchecker, :relay)}, {:username, Application.get_env(:jobchecker, :from)}, {:password, Application.get_env(:jobchecker, :email_password)}, {:port, Application.get_env(:jobchecker, :port)}]
    :gen_smtp_client.send(email,options)
  end
end
