defmodule Jobchecker.Jobs.Coinbase do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find("script#server-app-state")
    |> Floki.text([js: true])
    |> JSON.decode!()
    |> Map.get("suspenseBridgeData")
    |> JSON.decode!()
    |> hd()
    |> get_in(["data","departments"])
    |> Enum.map(fn x -> Map.get(x, "jobs") end)
    |> List.flatten()
    |> Enum.filter(fn x -> get_in(x, ["location", "name"]) == "Remote - USA" end)
    |> Enum.map(fn x -> {Map.get(x, "title"), "https://www.coinbase.com/careers/positions/" <> to_string(Map.get(x, "id"))} end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://www.coinbase.com/careers/positions?department=Engineering%2520-%2520Managers&location=remote", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
