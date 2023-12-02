defmodule Jobchecker.Jobs.Grafana do
  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("departments")
    |> Enum.flat_map(fn x ->
      Map.get(x, "jobs")
    end)
    |> Enum.filter(fn x -> String.match?(get_in(x, ["location", "name"]), ~r/United States/i) end)
    |> Enum.map(fn job -> {Map.get(job, "title"), Map.get(job, "absolute_url")} end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/grafanalabs/departments?content=true", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
