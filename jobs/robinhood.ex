defmodule Jobchecker.Jobs.Robinhood do
  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("jobs")
    |> Enum.filter(fn x ->
      get_in(x, ["location", "name"]) |> String.match?(~r/remote/i)
    end)
    |> Enum.map(fn x ->
      {Map.get(x, "title"), Map.get(x, "absolute_url")}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://api.greenhouse.io/v1/boards/robinhood/jobs", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
