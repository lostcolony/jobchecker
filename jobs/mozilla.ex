defmodule Jobchecker.Jobs.Mozilla do
  def start([url, terms]) do
    items = Jobchecker.Helpers.get_html(url)
    |> Floki.find(".title")

    titles = items
    |> Enum.map(&Floki.text/1)

    urls = items |> Floki.attribute("a", "href") |> Enum.map(fn x -> "https://www.mozilla.org/en-US/" <> x end)

    Enum.zip(titles, urls)
    |> Jobchecker.Helpers.filter(terms)
  end


  def test() do
    start(["https://www.mozilla.org/en-US/careers/listings/?location=Remote US", [~r/(manager|director)/i]])
  end
end
