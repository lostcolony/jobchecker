defmodule Jobchecker.Jobs.Stripe do
  def start([url, title_matches]) do
    html = Jobchecker.Helpers.get_html(url)
    |> Floki.find("td.JobsListings__tableCell")

    links = html
    |> Floki.find("a.JobsListings__link")
    |> Floki.attribute("href")
    |> Enum.map(fn x -> "https://stripe.com" <> x end)

    titles = html
    |> Floki.find("a.JobsListings__link")
    |> Enum.map(fn x -> String.trim(Floki.text(x)) end)

    Jobchecker.Helpers.filter(Enum.zip(titles, links), title_matches)
  end

  def test() do
    start(["https://stripe.com/jobs/search?remote_locations=North+America--US+Remote", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
