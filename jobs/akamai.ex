defmodule Jobchecker.Jobs.Akamai do
  def start([url, terms]) do
    HTTPoison.post!(url, ~s"""
        {"advancedSearchFiltersSelectionParam":{"searchFilterSelections":[{"id":"LOCATION","selectedValues":[]},{"id":"JOB_FIELD","selectedValues":[]},{"id":"URGENT_JOB","selectedValues":[]},{"id":"EMPLOYEE_STATUS","selectedValues":[]},{"id":"WILL_TRAVEL","selectedValues":[]},{"id":"JOB_SHIFT","selectedValues":[]}]},"fieldData":{"fields":{"JOB_NUMBER":"","JOB_TITLE":"","KEYWORD":""},"valid":true},"filterSelectionParam":{"searchFilterSelections":[{"id":"POSTING_DATE","selectedValues":[]},{"id":"ORGANIZATION","selectedValues":[]},{"id":"LOCATION","selectedValues":["217300106849"]},{"id":"JOB_FIELD","selectedValues":["338500106951"]},{"id":"JOB_TYPE","selectedValues":[]},{"id":"JOB_SCHEDULE","selectedValues":[]},{"id":"JOB_LEVEL","selectedValues":[]}]},"multilineEnabled":false,"pageNo":1,"sortingSelection":{"ascendingSortingOrder":"false","sortBySelectionParam":"3"}}
      """, [{"Host", "akamaicareers.inflightcloud.com"},
      {"Host", "akamaicareers.inflightcloud.com"},
      {"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0"},
      {"Accept", "*/*"},
      {"Accept-Language", "en-US,en;q=0.5"},
      {"Accept-Encoding", "gzip, deflate, br"},
      {"Referer", "https://akamaicareers.inflightcloud.com/search?searchable=%5B%7B%22id%22:%22217300106849%22,%22text%22:%22United%20States%22,%22portal%22:%228200106849%22,%22filterId%22:%22LOCATION%22%7D,%7B%22id%22:%22338500106951%22,%22text%22:%22Software%20Engineering%22,%22portal%22:%228200106849%22,%22filterId%22:%22JOB_FIELD%22%7D%5D&section=aka_ext"},
      {"content-type", "application/json"},
      {"tz", "GMT-08:00"},
      {"Content-Length", "868"},
      {"Origin", "https://akamaicareers.inflightcloud.com"},
      {"Connection", "keep-alive"},
      {"Sec-Fetch-Dest", "empty"},
      {"Sec-Fetch-Mode", "cors"},
      {"Sec-Fetch-Site", "same-origin"},
      {"Pragma", "no-cache"},
      {"Cache-Control", "no-cache"},
      {"TE", "trailers"}], []).body
    |> JSON.decode!()
    |> Map.get("requisitionList")
    |> Enum.map(fn x -> {hd(Map.get(x, "column")), "https://akamaicareers.inflightcloud.com/jobdetails/aka_ext/" <> Map.get(x, "contestNo")} end)
    |> Jobchecker.Helpers.filter(terms)

  end

  def test() do
    start(["https://akamaicareers.inflightcloud.com/careersection/rest/jobboard/searchjobs?portal=8200106849&lang=en", [~r/(manager|director)/i]])
  end
end
