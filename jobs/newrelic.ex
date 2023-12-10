defmodule Jobchecker.Jobs.NewRelic do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find("h3.article__header__text__title")
    |> Enum.map(fn x ->
      {Floki.text(x) |> String.trim(), Floki.attribute(x, "a", "href") |> to_string}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://newrelic.careers/en_US/careers/SearchJobs/?3141=162616&3141_format=2271&3865=%5B186268%5D&3865_format=2759&listFilterMode=1&jobRecordsPerPage=100&", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
