defmodule Jobchecker.Jobs.Github do
  def start([url, terms]) do
    recurse(url, 1)
    |> Enum.map(fn x ->
      data = Map.get(x, "data")
      {Map.get(data, "title"), "https://githubinc.jibeapply.com/jobs/" <> Map.get(data, "req_id")}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def recurse(url, page) do
    jobs = Jobchecker.Helpers.get_json(url <> "&page=#{page}")
    |> Map.get("jobs")

    case jobs do
      [] -> []
      _ -> jobs ++ recurse(url, page+1)
    end
  end

  def test() do
    start(["https://githubinc.jibeapply.com/api/jobs?locations=Remote,,United States&sortBy=relevance&descending=false&internal=false", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
