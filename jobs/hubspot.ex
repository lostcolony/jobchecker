defmodule Jobchecker.Jobs.Hubspot do
  def start([url, terms]) do
    HTTPoison.post!(url, ~s"""
        {"operationName":"Jobs","variables":{"departmentIds":[12780,9908,63933,63932,64162],"officeIds":[43769,57033,61530,43765,43767,43770,43768,43766,80765,80764,85797,85799,85798,88301,88305],"languages":[],"roleTypes":[]},"query":"query Jobs($departmentIds: [Int], $officeIds: [Int], $languages: [String], $roleTypes: [String], $searchQuery: String) {  jobs(departmentIds: $departmentIds, officeIds: $officeIds, languages: $languages, roleTypes: $roleTypes, searchQuery: $searchQuery) {    id    title    department {      name      id      __typename    }    office {      id      location      __typename    }    location {      name      __typename    }    __typename  }}"}
      """, [{"Host", "wtcfns.hubspot.com"},
      {"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/118.0"},
      {"Accept", "application/json"},
      {"Accept-Language", "en-US"},
      {"Referer", "https://www.hubspot.com/careers/jobs/all?page=1"},
      {"Content-Type", "application/json"},
      {"Content-Length", "261"},
      {"Origin", "https://www.hubspot.com"},
      {"DNT", "1"},
      {"Connection", "keep-alive"},
      {"Sec-Fetch-Dest", "empty"},
      {"Sec-Fetch-Mode", "cors"},
      {"Sec-Fetch-Site", "same-origin"}], []).body
    |> JSON.decode!()
    |> get_in(["data", "jobs"])
    |> Enum.filter(fn x -> get_in(x, ["location", "name"]) == "Remote - USA" end)
    |> Enum.map(fn x -> {Map.get(x, "title"), "https://www.hubspot.com/careers/jobs/" <> to_string(Map.get(x, "id"))} end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://wtcfns.hubspot.com/careers/graphql", [~r/(manager|director|lead)/i]])
  end
end
