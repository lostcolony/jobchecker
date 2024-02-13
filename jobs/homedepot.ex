defmodule Jobchecker.Jobs.HomeDepot do
  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("searchResults")
    |> Enum.map(fn x ->
      {get_in(x, ["job", "title"]), get_in(x, ["job", "url"])}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://jobsapi-google.m-cloud.io/api/job/search?pageSize=100&offset=0&companyName=companies%2F8454851f-07b7-4e4c-9b5f-00e0ffbfcb09&query=Software%20Engineer%20Manager%20(Remote)&locationFilter[]={%22telecommutePreference%22%3A%22TELECOMMUTE_ALLOWED%22}&customAttributeFilter=parent_category%3D%22Corporate%22%20AND%20(primary_category%3D%22Technicians%22%20OR%20primary_category%3D%22Technology%22)%20AND%20(ats_portalid%3D%22KBR-5032%22%20OR%20ats_portalid%3D%22Workday%22)&orderBy=relevance%20desc", []])
  end
end
