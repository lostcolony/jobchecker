defmodule Jobchecker.Jobs.Netflix do
  def start([url, filters]) do
    recurse(url, 0, filters)
  end

  def recurse(url, page, filters) do
    json = Jobchecker.Helpers.get_json(url)
    pages = get_in(json, ["info", "postings", "num_pages"])
    items = getItems(json, filters)
    case page < pages do
      true -> items ++ recurse(url, page+1, filters)
      false -> items
    end
  end

  def getItems(json, filters) do
    get_in(json, ["records", "postings"])
    |> Enum.map(fn x -> {Map.get(x, "text"), "https://jobs.netflix.com/jobs/" <> Map.get(x, "external_id")} end)
    |> Jobchecker.Helpers.filter(filters)
  end

  def test() do
    start(["https://jobs.netflix.com/api/search?location=Remote,%20United%20States", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
