defmodule Jobchecker.Jobs.Elastic do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find("td.col-md-6")
    |> Enum.chunk_every(2)
    |> Enum.map(fn [a, b ] ->
      job = Floki.find(a, "a")
      title = Floki.text(job)
      url = "https://jobs.elastic.co" <> hd(Floki.attribute(job, "href"))
      location = Floki.text(b) |> String.trim()
      {{title, url}, location}end)
    |> Enum.filter(fn {_, location} -> String.match?(location, ~r/United States/i) end)
    |> Enum.map(fn x -> elem(x, 0) end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://jobs.elastic.co/jobs/department/engineering?#/", [~r/(manager|director|lead)/i]])
  end
end
