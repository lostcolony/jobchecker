defmodule Jobchecker.Jobs.Oracle do
  def start([url, terms]) do
    recurse(url, 0, terms)
  end

  def recurse(url, offset, filters) do
    json = HTTPoison.get!(url <> ",offset=#{offset}", [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}], [{:timeout, 10000}, {:recv_timeout, 10000}]).body
      |> JSON.decode!()
      |> Map.get("items")
      |> Enum.at(0)

    shouldRecurse = Map.get(json, "Limit") + Map.get(json, "Offset") < Map.get(json, "TotalJobsCount")
    items = getItems(Map.get(json, "requisitionList"), filters)
    case shouldRecurse do
      true -> items ++ recurse(url, offset + Map.get(json, "Limit"), filters)
      false -> items
    end
  end

  def getItems(json, filters) do
    json
    |> Enum.map(fn x -> {Map.get(x, "Title"), "https://careers.oracle.com/jobs/#en/sites/jobsearch/job/" <> Map.get(x, "Id")} end)
    |> Jobchecker.Helpers.filter(filters)
  end

  def test() do
    start(["https://eeho.fa.us2.oraclecloud.com/hcmRestApi/resources/latest/recruitingCEJobRequisitions?onlyData=true&expand=requisitionList.secondaryLocations,flexFieldsFacet.values&finder=findReqs;siteNumber=CX_45001,facetsList=LOCATIONS%3BWORK_LOCATIONS%3BWORKPLACE_TYPES%3BTITLES%3BCATEGORIES%3BORGANIZATIONS%3BPOSTING_DATES%3BFLEX_FIELDS,limit=14,lastSelectedFacet=POSTING_DATES,locationId=300000000149325,selectedCategoriesFacet=300000001917356,selectedLocationsFacet=300000000149325,selectedPostingDatesFacet=7,sortBy=POSTING_DATES_DESC",
    [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
