defmodule Jobchecker.Jobs.Doordash do
  def start([url, terms]) do
    html = Jobchecker.Helpers.get_html(url)

    titles = Floki.find(html, "div.jp-title") |> Enum.map(fn x -> String.trim(Floki.text(x)) end)
    urls = Floki.find(html, "a.jp-viewjob_button") |> Floki.attribute("href") |> Enum.map(fn x -> "https://careers.doordash.com" <> x end)

    Enum.zip(titles, urls)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://careers.doordash.com/career-areas/engineering", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
