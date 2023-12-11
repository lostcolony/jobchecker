defmodule Jobchecker.Jobs.Crowdstrike do
  def start([url, terms]) do
    json = HTTPoison.post!(url, ~s"""
    {"appliedFacets":{"locationCountry":["bc33aa3152ec42d4995f4791a106ed09"],"locations":["20feac86ebdd0102586dc95b42138d6f"],"Job_Family":["1408861ee6e201641be2c2f6b000c00b"]},"limit":20,"offset":0,"searchText":""}
    """, [{"Accept", "application/json"},
    {"Accept-Language", "en-US"},
    {"Referer", "https://crowdstrike.wd5.myworkdayjobs.com/crowdstrikecareers?locationCountry=bc33aa3152ec42d4995f4791a106ed09&locations=20feac86ebdd0102586dc95b42138d6f&Job_Family=1408861ee6e201641be2c2f6b000c00b"},
    {"Content-Type", "application/json"},
    {"Origin", "https://crowdstrike.wd5.myworkdayjobs.com"},
    {"Connection", "keep-alive"},
    {"Sec-Fetch-Dest", "empty"},
    {"Sec-Fetch-Mode", "cors"},
    {"Sec-Fetch-Site", "same-origin"},
    {"Pragma", "no-cache"},
    {"Cache-Control", "no-cache"},], []).body
    |> JSON.decode!()
    |> Map.get("jobPostings")


    urls = json
    |> Enum.map(fn x -> "https://crowdstrike.wd5.myworkdayjobs.com/en-US/crowdstrikecareers" <> Map.get(x, "externalPath") end)

    titles = json
    |> Enum.map(fn x -> Map.get(x, "title") end)

    Enum.zip(titles, urls)
    |> Jobchecker.Helpers.filter(terms)

  end

  def test() do
    start(["https://crowdstrike.wd5.myworkdayjobs.com/wday/cxs/crowdstrike/crowdstrikecareers/jobs", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
