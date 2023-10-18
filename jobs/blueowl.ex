defmodule Jobchecker.Jobs.Blueowl do
  def start([url, terms]) do
    found = Jobchecker.Helpers.get_html(url)
    |> Floki.find("[data-mapped=true]")

    urls = found |> Floki.attribute("href") |> Enum.map(fn x -> "https://boards.greenhouse.io" <> x end)

    titles = found |> Enum.map(fn x -> Floki.text(x) end)

    Enum.zip(titles, urls)
    |> Enum.filter(fn x -> String.match?(elem(x, 0), ~r/remote/i) end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://boards.greenhouse.io/blueowl", []])
  end
end
