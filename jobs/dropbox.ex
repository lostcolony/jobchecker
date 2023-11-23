defmodule Jobchecker.Jobs.Dropbox do
  def start([url, terms]) do
    parsed = Jobchecker.Helpers.get_html(url)

    titles = parsed |> Floki.find(".open-positions__listing-title") |> Enum.map(&Floki.text/1)
    locations = parsed |> Floki.find(".open-positions__listing-location") |> Enum.map(&Floki.text/1)
    urls = parsed |> Floki.find(".open-positions__cta-link") |> Floki.attribute("href")

    Enum.zip([titles, locations, urls])
    |> Enum.filter(fn {_, location, _} -> location == "Remote - US" || String.match?(location, ~r/California/) end)
    |> Enum.map(fn {title, _, url} -> {title, url} end)
    |> Jobchecker.Helpers.filter(terms)
  end


  def test() do
    start(["https://jobs.dropbox.com/teams/engineering", [~r/(manager|director)/i]])
  end
end
