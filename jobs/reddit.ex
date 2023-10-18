defmodule Jobchecker.Jobs.Reddit do
  def start([url, terms]) do
    html = Jobchecker.Helpers.get_html(url)

    items = Floki.find(html, "[data-mapped=true]")

    urls = Floki.attribute(items, "href")
    |> Enum.map(fn x -> "https://boards.greenhouse.io" <> x end)

    titles = Enum.map(items, &Floki.text/1)

    locations = html |> Floki.find("span.location") |> Enum.map(&Floki.text/1)

    Enum.zip([titles, urls, locations])
    |> Enum.filter(fn {_, _, location} -> location == "Remote - United States" end)
    |> Jobchecker.Helpers.filter(terms)
    |> Enum.map(fn {title, url, _} -> {title, url} end)
  end

  @spec test() :: list()
  def test() do
    start(["https://boards.greenhouse.io/reddit", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
