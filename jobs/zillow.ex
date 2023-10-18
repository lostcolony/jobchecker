defmodule Jobchecker.Jobs.Zillow do

  def start([url, terms]) do
    json = HTTPoison.post!(url, ~s"""
    {"appliedFacets":{"locations":["bf3166a9227a01f8b514f0b00b147bc9"],"workerSubType":["156fb9a2f01c10bed80e140d011a9559"],"timeType":["156fb9a2f01c10be203b6e91581a01d1"],"jobFamilyGroup":["a90eab1aaed6105e8dd41df427a82ee6"]},"limit":20,"offset":0,"searchText":""}
    """, [{"Host", "zillow.wd5.myworkdayjobs.com"},
    {"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/118.0"},
    {"Accept", "application/json"},
    {"Accept-Language", "en-US"},
    {"Referer", "https://zillow.wd5.myworkdayjobs.com/Zillow_Group_External?locations=bf3166a9227a01f8b514f0b00b147bc9&workerSubType=156fb9a2f01c10bed80e140d011a9559&timeType=156fb9a2f01c10be203b6e91581a01d1&jobFamilyGroup=a90eab1aaed6105e8dd41df427a82ee6"},
    {"Content-Type", "application/json"},
    {"Content-Length", "261"},
    {"Origin", "https://zillow.wd5.myworkdayjobs.com"},
    {"DNT", "1"},
    {"Connection", "keep-alive"},
    {"Sec-Fetch-Dest", "empty"},
    {"Sec-Fetch-Mode", "cors"},
    {"Sec-Fetch-Site", "same-origin"}], []).body
    |> JSON.decode!()
    |> Map.get("jobPostings")

    urls = json
    |> Enum.map(fn x -> "https://zillow.wd5.myworkdayjobs.com/en-US/Zillow_Group_External" <> Map.get(x, "externalPath") end)

    titles = json
    |> Enum.map(fn x -> Map.get(x, "title") end)

    Enum.zip(titles, urls)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://zillow.wd5.myworkdayjobs.com/wday/cxs/zillow/Zillow_Group_External/jobs", [~r/(manager|director)/i]])
  end
end
