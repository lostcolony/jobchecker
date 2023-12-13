defmodule Jobchecker.Jobs.Confluent do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find("div.jobs-section__item")
    |> Floki.find("a")
    |> Enum.map(fn x ->
      {Floki.text(x), to_string(Floki.attribute(x, "href"))}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://careers.confluent.io/search/engineering/jobs/in/country/united-states", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
