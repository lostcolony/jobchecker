defmodule Jobchecker.Jobs.Discord do

  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("jobs")
    |> Enum.filter(fn x -> String.match?(get_in(x, ["location", "name"]), ~r/remote/i) end)
    |> Enum.map(fn job ->
        {Map.get(job, "title"), "https://discord.com/jobs/" <> Integer.to_string(Map.get(job, "id"))}
      end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://api.greenhouse.io/v1/boards/discord/jobs?content=true", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
