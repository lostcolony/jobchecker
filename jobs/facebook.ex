defmodule Jobchecker.Jobs.Facebook do
  def start([url, terms]) do
    parsed = HTTPoison.get!(url, [{"Accept",
      "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"},
      {"Accept-Encoding",
      "html"},
      {"Accept-Language",
      "en-US,en;q=0.9"},
      {"Sec-Ch-Ua:",
      "\"Google Chrome\";v=\"117\", \"Not;A=Brand\";v=\"8\", \"Chromium\";v=\"117\""},
      {"Sec-Ch-Ua-Mobile",
      "?0"},
      {"Sec-Ch-Ua-Platform",
      "Windows"},
      {"Sec-Fetch-Dest",
      "document"},
      {"Sec-Fetch-Mode",
      "navigate"},
      {"Sec-Fetch-Site",
      "none"},
      {"Sec-Fetch-User",
      "?1"},
      {"Upgrade-Insecure-Requests",
      "1"},
      {"User-Agent",
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"}], [{:timeout, 10000}, {:recv_timeout, 10000}]).body
      |> Floki.parse_document!()
      |> Floki.find("div._af0h")

    urls = Floki.find(parsed, "a._8sef")
    |> Enum.map(fn x -> "https://www.metacareers.com" <> Enum.at(Floki.attribute(x, "href"), 0) end)

    titles = Floki.find(parsed, "div._8sel")
    |> Enum.map(fn x -> Floki.text(x) end)

    Enum.zip(titles, urls)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://www.metacareers.com/areas-of-work/Facebook%20App/?p[divisions][0]=Facebook&divisions[0]=Facebook&offices[0]=Remote%2C%20US&leadership_levels[0]=People%20Manager#openpositions", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
