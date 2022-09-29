defmodule Orchestration do
  def load_jobs(file) do
    elem(Code.eval_file(file), 0)
  end

  def spin_up_checker(job_tuple) do
    spawn_link(Jobchecker, :init, [job_tuple, self()])
  end

  def fan_out(jobs) do
    Process.flag(:trap_exit, true)

    lookup = Enum.map(jobs, fn job -> {elem(job, 0), spin_up_checker(job)} end)
    |> Enum.reduce(%{}, fn ({company, reference}, map) -> Map.put_new(map, reference, company) end)
    count = map_size(lookup)

    listen(lookup, count, %{})
  end

  def listen(_, 0, acc) do
    jobs_to_email_out =
      for {company, jobs} <- acc do
        if is_list(jobs) && jobs != [] do
          previous_jobs = Persistence.retrieve_jobs(company)
          new_jobs =
            if previous_jobs != nil && List.first(jobs) != nil do
              jobs -- previous_jobs.jobs
            else
              jobs
            end
          Persistence.insert_jobs(company, jobs)
          {company, new_jobs}
        end
      end
    #email out jobs_to_email_out ([{company, jobs}])
    jobs_to_email_out
  end
  def listen(map, count, acc) do
    {count, acc} =
      receive do
        {:EXIT, _, :normal} -> {count - 1, acc}
        {:EXIT, pid, failure} -> {count - 1, Map.put(acc, Map.get(map, pid), failure)}
        {company, jobs} -> {count, Map.put(acc, company, jobs)}
      end
    listen(map, count, acc)
  end
end
