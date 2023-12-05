defmodule Jobchecker.Jobs.Builtin do
  def start([url, terms]) do
    html = Jobchecker.Helpers.get_html(url)

    jobs = html
    |> Floki.find("a#job-card-alias")
    |> Enum.map(fn x ->
      {Floki.text(x), "https://builtin.com"<> to_string(Floki.attribute(x, "href"))}
    end)

    companies = Floki.find(html, "div[data-id=company-title]")
    |> Enum.map(&Floki.text/1)

    Enum.zip(companies, jobs)
    |> Enum.map(fn {company, job} ->
      {to_string(company) <> " - " <> elem(job, 0), elem(job, 1) }
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://builtin.com/jobs/remote/dev-engineering/management/201-500/501-1000/1000", []])
  end
end
