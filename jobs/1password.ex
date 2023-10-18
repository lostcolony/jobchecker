defmodule Jobchecker.Jobs.OnePassword do
  def start([url, terms]) do
    jobs = Jobchecker.Helpers.get_html(url)
    |> Floki.find("a.posting-title")

    titles = jobs
    |> Floki.find("h5")
    |> Enum.map(&Floki.text/1)

    urls = jobs |> Floki.attribute("href")

    Enum.zip(titles, urls)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://jobs.lever.co/1password?workplaceType=remote&location=Remote%20%28US%20or%20Canada%29&department=Technology", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
