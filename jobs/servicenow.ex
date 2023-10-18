defmodule Jobchecker.Jobs.Servicenow do
  alias Jobchecker.Jobs
  def start([url, terms]) do
    jobs = Jobchecker.Helpers.get_json(url)
    |> Map.get("jobs")

    titles = jobs
    |> Enum.map(fn x -> get_in(x, ["data", "title"]) end)

    urls = jobs
    |> Enum.map(fn x -> get_in(x, ["data", "meta_data", "canonical_url"]) end)

    req = jobs
    |> Enum.map(fn x -> get_in(x, ["data", "req_id"]) end)

    Enum.zip([req, titles, urls])
    |> Enum.reduce(Map.new(), fn ({req, title, url}, acc) ->
      Map.put(acc, req, {title, url})
    end)
    |> Map.values()
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://careers.servicenow.com/api/jobs?categories=Digital%2520Technology%257CEngineering%252C%2520Infrastructure%2520and%2520Operations&page=1&tags6=Remote&sortBy=relevance&descending=false&internal=false&tags8=OFFER%7CSOURCING%7CINTERVIEW", []])
  end
end
