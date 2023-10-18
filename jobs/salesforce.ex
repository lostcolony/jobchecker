defmodule Jobchecker.Jobs.Salesforce do
  def start([url, terms]) do
    get_pages(url)
    |> Jobchecker.Helpers.filter(terms)
  end

  def get_pages(url) do
    html = Jobchecker.Helpers.get_html(url)

    text = Floki.find(html, "p.job-count")
    |> hd()
    |> Floki.text()

    item_count = Regex.run(~r/Displaying [\d]+ to [\d]+ of (\d+)/, text)
    |> Enum.at(1)
    |> Integer.parse()
    |> elem(0)

    pages = item_count / 50
    |> Float.ceil()

    acc = parse_out_jobs(html)
    get_pages(url, 2, pages, acc)
  end

  def parse_out_jobs(html) do
    items = html |> Floki.find("a.js-view-job")

    urls = Floki.attribute(items, "href")
    |> Enum.map(fn x -> "https://careers.salesforce.com" <> x end)

    titles = Enum.map(items, &Floki.text/1)
    Enum.zip(titles, urls)
  end

  def get_pages(_, current_page, total_pages, acc) when current_page > total_pages do
    acc
  end
  def get_pages(url, current_page, total_pages, acc) do
    html = Jobchecker.Helpers.get_html(url <> "&page=#{current_page}")
    jobs = parse_out_jobs(html)
    get_pages(url, current_page + 1, total_pages, acc ++ jobs)
  end

  def test() do
    start(["https://careers.salesforce.com/en/jobs/?country=United%20States%20of%20America&location=Remote&type=Full%20time&jobtype=Regular&pagesize=50", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
