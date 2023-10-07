defmodule Orchestration do
  require Logger


  def run() do
    Logger.debug("Executing...")
    names_and_funcs = elem(Code.eval_file("./jobs/jobs.exs"),0)
    lookup = fan_out(names_and_funcs)

    count = map_size(lookup)

    results = listen(lookup, count, %{})

    {jobs, failures} = Enum.split_with(results, fn x -> case x do
      {company, jobs} when is_binary(company) and is_list(jobs) -> true
      _ -> false
    end
    end)

    new_jobs = get_new_jobs(jobs)
    new_failures = get_new_failures(failures)
    email_new_jobs(new_jobs, new_failures)
    persist_jobs(jobs)
    persist_failures(new_jobs, failures)
    Logger.debug("Finished, sleeping to next run")
    Process.sleep(60*60*1000)
    run()
  end

  def load_jobs(file) do
    elem(Code.eval_file(file), 0)
  end

  def spin_up_checker(job_tuple) do
    spawn_link(Jobchecker, :init, [job_tuple, self()])
  end

  def fan_out(name_and_funcs) do
    Process.flag(:trap_exit, true)

    Enum.map(name_and_funcs, fn {name, func, args} -> {name, spin_up_checker({name, func, args})} end)
    |> Enum.reduce(%{}, fn ({company, reference}, map) -> Map.put_new(map, reference, company) end)
  end

  def get_new_jobs(scraped_jobs) do
    for {company, jobs} <- scraped_jobs do
      if is_list(jobs) && jobs != [] do
        jobs = Enum.uniq(jobs)
        previous_jobs = Jobchecker.Persistence.retrieve_jobs(company)
        new_jobs =
          if previous_jobs != nil do
            previous_jobs = Enum.map(previous_jobs.jobs, fn ({title, url, _}) -> {title, url} end)
            jobs -- previous_jobs
          else
            jobs
          end
        {company, new_jobs}
      else
        {company, []}
      end
    end
  end

  def get_new_failures(failures) do
    List.flatten(for {company, failure} <- failures do
      previous_failures = Jobchecker.Persistence.retrieve_failures(company)
      if previous_failures != nil do
        []
      else
        {company, failure}
      end
    end)
  end

  def persist_jobs(scraped_jobs) do
    now = DateTime.to_unix(DateTime.utc_now())
    for {company, jobs} <- scraped_jobs do
      if is_list(jobs) && jobs != [] do
        old_jobs = case Jobchecker.Persistence.retrieve_jobs(company) do
          nil -> []
          a -> a.jobs
        end


        old_jobs = Enum.filter(old_jobs, fn {_title, _url, time} ->
          time > now - 24*60*60*1000
        end)

        jobs = Enum.map(jobs, fn({title, url}) -> {title, url, now} end)

        jobs = old_jobs ++ jobs

        map = Enum.reduce(jobs, Map.new(), fn({title, url, time}, inner_map) ->
          Map.put(inner_map, {title, url}, {title, url, time})
        end)
        Jobchecker.Persistence.insert_jobs(company, Map.values(map))
      end
    end
  end

  def persist_failures(jobs, failures) do
    for {company, _} <- jobs do
      Jobchecker.Persistence.clear_failure(company)
    end

    for {company, failure} <- failures do
      Jobchecker.Persistence.insert_failures(company, failure)
    end
  end

  def listen(_, 0, acc), do: acc
  def listen(map, count, acc) do
    {count, acc} =
      receive do
        {:EXIT, _, :normal} -> {count - 1, acc}
        {:EXIT, pid, failure} ->
          IO.puts("Failure:" <> inspect(Map.get(map, pid)) <> inspect(failure))
          {count - 1, Map.put(acc, Map.get(map, pid), failure)}
        {company, jobs} -> {count, Map.put(acc, company, jobs)}
      end
    listen(map, count, acc)
  end


  def email_new_jobs(jobs, failures) do
    body = Enum.map(jobs, fn ({company, job_list}) ->
      if job_list == [] do
        ""
      else
        company <> ":\r\n\t" <>
        (Enum.map(job_list, fn ({title, url}) -> title <> ": " <> url end) |> Enum.join("\r\n\t")) <> "\r\n\r\n"
      end
    end) |> Enum.join()

    body = body <> (Enum.map(failures, fn {company, failure} -> company <> ":\r\n\t" <> inspect(failure) end) |> Enum.join())
    case String.length(body) do
      0 -> :ok
      _ -> send_email(body)
    end
  end



  def send_email(body) do

    IO.inspect(body)
    email = {Application.get_env(:jobchecker, :from), [Application.get_env(:jobchecker, :to)],
    "Subject: Jobcheck Jobs\r\nFrom: Jobchecker <#{Application.get_env(:jobchecker, :from)}>\r\nTo: You\r\n\r\n#{body}"}


    options = [{:relay, Application.get_env(:jobchecker, :relay)}, {:username, Application.get_env(:jobchecker, :from)}, {:password, Application.get_env(:jobchecker, :email_password)}, {:port, Application.get_env(:jobchecker, :port)}]
    IO.inspect(:gen_smtp_client.send_blocking(email,options))
  end
end
