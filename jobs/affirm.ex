defmodule Jobchecker.Jobs.Affirm do
  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("jobs")
    |> Enum.filter(fn x -> get_in(x, ["location", "name"]) == "Remote US" end)
    |> Enum.map(fn job ->
        {Map.get(job, "title"), Map.get(job, "absolute_url")}
      end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/affirm/jobs/", []])
  end
end
