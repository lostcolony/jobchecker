defmodule Jobchecker.Jobs.Nvidia do

  def start([url, terms]) do
    case HTTPoison.post!(url, ~s"""
    {"appliedFacets":{"locationHierarchy2":["0c3f5f117e9a0101f63dc469c3010000"],"locationHierarchy1":["2fcb99c455831013ea52fb338f2932d8"],"jobFamilyGroup":["0c40f6bd1d8f10ae43ffaefd46dc7e78"],"workerSubType":["0c40f6bd1d8f10adf6dae2cd57444a16"]},"limit":20,"offset":0,"searchText":""}
    """, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/118.0"},
    {"Accept", "application/json"},
    {"Accept-Language", "en-US"},
    {"Referer", "https://nvidia.wd5.myworkdayjobs.com/NVIDIAExternalCareerSite?locationHierarchy2=0c3f5f117e9a0101f63dc469c3010000&locationHierarchy1=2fcb99c455831013ea52fb338f2932d8&jobFamilyGroup=0c40f6bd1d8f10ae43ffaefd46dc7e78&workerSubType=0c40f6bd1d8f10adf6dae2cd57444a16"},
    {"Content-Type", "application/json"},
    {"Origin", "https://nvidia.wd5.myworkdayjobs.com"},
    {"Connection", "keep-alive"},
    {"Sec-Fetch-Dest", "empty"},
    {"Sec-Fetch-Mode", "cors"},
    {"Sec-Fetch-Site", "same-origin"},
    {"Pragma", "no-cache"},
    {"Cache-Control", "no-cache"}]) do
      %HTTPoison.MaybeRedirect{redirect_url: redirect_url } -> start([redirect_url, terms])
      a -> a.body
        |> JSON.decode!()
        |> Map.get("jobPostings")
        |> Enum.map(fn job -> {Map.get(job, "title"), "https://nvidia.wd5.myworkdayjobs.com/en-US/NVIDIAExternalCareerSite" <> Map.get(job, "externalPath")} end)
        |> Jobchecker.Helpers.filter(terms)
    end
  end

  def test() do
    start(["https://nvidia.wd5.myworkdayjobs.com/wday/cxs/nvidia/NVIDIAExternalCareerSite/jobs", []])
  end
end
