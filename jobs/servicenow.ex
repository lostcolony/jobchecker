defmodule Jobchecker.Jobs.Servicenow do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find(".js-view-job")
    |> Enum.map(fn x ->
      url = "https://careers.servicenow.com/" <> to_string(Floki.find(x, "a") |> Floki.attribute("href"))
      {Floki.text(x), url}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://careers.servicenow.com/en/jobs/?search=&team=Engineering%2C+Infrastructure+and+Operations&country=United+States&remote=true&pagesize=100#results", []])
  end
end
