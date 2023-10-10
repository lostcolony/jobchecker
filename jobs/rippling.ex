defmodule Jobchecker.Jobs.Rippling do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find("script#__NEXT_DATA__")
    |> Floki.text([js: true])
    |> JSON.decode!()
    |> get_in(["props", "pageProps", "jobs"])
    |> Enum.filter(fn job ->
      get_in(job, ["department", "label"]) == "Engineering" &&
      get_in(job, ["workLocation", "label"]) == "Remote (United States)" &&
      !String.match?(Map.get(job, "name"), ~r/Return to India/i)
    end)
    |> Enum.map(fn x -> {Map.get(x, "name"), Map.get(x, "url")} end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://www.rippling.com/careers/open-roles", []])
  end
end
