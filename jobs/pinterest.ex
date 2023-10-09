defmodule Jobchecker.Jobs.Pinterest do
  def start([url, filters]) do
    jobs = Jobchecker.Helpers.get_html(url)
    |> Floki.find("a.js-view-job")

    urls = jobs
    |> Floki.attribute("href")
    |> Enum.map(fn x -> "https://www.pinterestcareers.com" <> x end)

    titles = jobs |> Enum.map(fn x -> String.trim(Floki.text(x)) end)

    Enum.zip(titles, urls)
    |> Jobchecker.Helpers.filter(filters)
  end

  def test() do
    start(["https://www.pinterestcareers.com/en/jobs/?search=&team=Engineering&remote=true&pagesize=300#results", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
