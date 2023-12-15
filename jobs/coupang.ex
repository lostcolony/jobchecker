defmodule Jobchecker.Jobs.Coupang do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find("div.card-job")
    |> Floki.find("a.stretched-link")
    |> Enum.map(fn x ->
      {Floki.text(x), "https://www.coupang.jobs" <> to_string(Floki.attribute(x, "href"))}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://www.coupang.jobs/en/jobs/?search=&location=USA+Remote&remote=true&pagesize=40#results", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
