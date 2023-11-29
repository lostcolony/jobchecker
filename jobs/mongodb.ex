defmodule Jobchecker.Jobs.Mongodb do

  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("jobs")
    |> Enum.filter(fn x ->
      location = get_in(x, ["location", "name"])
      String.match?(location, ~r/remote california/i) || String.match?(location, ~r/remote north america/i)
    end)
    |> Enum.map(fn job ->
        {Map.get(job, "title"), Map.get(job, "absolute_url")}
      end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://api.greenhouse.io/v1/boards/mongodb/jobs?content=true", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
