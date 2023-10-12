defmodule Jobchecker.Jobs.Cloudflare do

  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("departments")
    |> Enum.map(fn x -> Map.get(x, "jobs") end)
    |> List.flatten()
    |> Enum.filter(fn x -> String.match?(get_in(x, ["location", "name"]), ~r/[R|r]emote US|[R|r]emote.*[NY|WA|CA|IL|TX]/) end)
    |> Enum.map(fn x ->
      id = Map.get(x, "id")

      if (id == 3617453) do
        IO.inspect(x)
      end
      x
    end)
    |> Enum.map(fn job -> {Map.get(job, "title"), Map.get(job, "absolute_url")} end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/cloudflare/departments/?render_as=tree", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
