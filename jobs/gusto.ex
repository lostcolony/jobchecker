defmodule Jobchecker.Jobs.Gusto do
  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("jobs")
    |> Enum.filter(fn job ->
      Map.get(job, "offices")
      |> Enum.any?(fn office ->
        case Map.get(office, "location") do
          x when is_binary(x) -> String.match?(x, ~r/united states/i)
          _ -> false
        end
      end)
    end)
    |> Enum.map(fn job ->
        {Map.get(job, "title"), Map.get(job, "absolute_url")}
      end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/gusto/jobs?content=true", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
