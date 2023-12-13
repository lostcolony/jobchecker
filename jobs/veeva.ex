defmodule Jobchecker.Jobs.Veeva do
  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("searchResults")
    |> Enum.map(fn x ->
      job = Map.get(x, "job")
      {Map.get(job, "title"), Map.get(job, "url")}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://jobsapi-google.m-cloud.io/api/job/search?pageSize=96&offset=0&companyName=companies%2F77bbdcce-f3f1-48c6-9948-124b17070768&locationFilter[]={%22telecommutePreference%22%3A%22TELECOMMUTE_ALLOWED%22}&customAttributeFilter=primary_category%3D%22Engineering%22%20AND%20store_id%3D%22USA%22%20&orderBy=posting_publish_time%20desc", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
