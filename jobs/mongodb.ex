defmodule Jobchecker.Jobs.Mongodb do

  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find("script#data-grnhs")
    |> Floki.text([js: true])
    |> JSON.decode!()
    |> Map.get("jobs")
    |> Enum.map(fn x -> {Map.get(x, "title"), "https://www.mongodb.com/careers/jobs/" <> Integer.to_string(Map.get(x, "id"))} end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://www.mongodb.com/careers/positions", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
