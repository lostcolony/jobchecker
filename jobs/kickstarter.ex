defmodule Jobchecker.Jobs.Kickstarter do
  def start([url, terms]) do
    items = Jobchecker.Helpers.get_html(url)
    |> Floki.find("[data-mapped=true]")

    urls = Floki.attribute(items, "href")

    titles = Enum.map(items, &Floki.text/1)

    Enum.zip(titles, urls)
    |> Jobchecker.Helpers.filter(terms)
  end


  #data-mapped
  def test() do
    start(["https://boards.greenhouse.io/embed/job_board?for=kickstarter&b=https%3A%2F%2Fjobs.kickstarter.com%2F", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
