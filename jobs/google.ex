defmodule Jobchecker.Jobs.Google do

  def start([url, terms]) do
    start([url, terms], [], 1)
  end

  def start([url, terms], acc, page) do
    items = _get_current_page(url <> "&page=#{page}", terms)
    case items do
      [] -> acc
      [_ | _] -> start([url, terms], acc ++ items, page+1)
    end
  end

  def _get_current_page(url, terms) do
    parsed = Jobchecker.Helpers.get_html(url)

    titles = parsed
    |> Floki.find("ul > li > div h3")
    |> Enum.map(fn x -> Floki.text(x) end)

    urls = parsed
    |> Floki.find("ul > li > div a")
    |> Floki.attribute("href")
    |> Enum.map(fn x -> "https://www.google.com/about/careers/applications/" <> x end)

    Enum.zip(titles, urls)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://www.google.com/about/careers/applications/jobs/results?has_remote=true&employment_type=FULL_TIME&location=United+States&sort_by=date&target_level=DIRECTOR_PLUS&target_level=ADVANCED", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
