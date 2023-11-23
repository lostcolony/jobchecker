defmodule Jobchecker.Jobs.Instacart do
  def start([url, terms]) do
    entries = HTTPoison.post!(url, ~s"""
        action=searchAndListAllDepartmentJobs&sval=&gh_src=
      """, [{"Host", "instacart.careers"},
      {"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/118.0"},
      {"Accept", "application/json"},
      {"Accept-Language", "en-US"},
      {"Referer", "https://instacart.careers/current-openings/"},
      {"Content-Type", "application/x-www-form-urlencoded; charset=UTF-8"},
      {"Content-Length", "51"},
      {"Origin", "https://instacart.careers"},
      {"DNT", "1"},
      {"Connection", "keep-alive"},
      {"Sec-Fetch-Dest", "empty"},
      {"Sec-Fetch-Mode", "cors"},
      {"Sec-Fetch-Site", "same-origin"}], []).body
    |> JSON.decode!()
    |> Map.get("message")
    |> Floki.parse_document!()
    |> Floki.find(".jobs-section")

    locations = entries |> Enum.map(fn x -> Floki.find(x, "span") |> Enum.at(1) |> elem(2) |> hd() end)

    attributes = entries |> Enum.map(fn x -> Floki.find(x, "a") |> hd()  end)

    titles_urls = Enum.map(attributes, fn x -> {Floki.text(x), hd(Floki.attribute(x,"href"))} end)

    Enum.zip(locations, titles_urls)
    |> Enum.filter(fn {x, _} -> x == "Remote - United States" || x == "United States - Remote" end)
    |> Enum.map(fn {_, titles_urls} -> titles_urls end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://instacart.careers/wp-admin/admin-ajax.php", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
