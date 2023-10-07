defmodule Jobchecker.Jobs.Atlassian do
  def start([url, title_match]) do
    HTTPoison.get!(url, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}], []).body
    |> JSON.decode!()
    |> Enum.filter(fn %{"title" => title, "locations" => locations} = job ->
      category = Map.get(job, "category") #Can be nil; going to just treat them as though they're engineering until I see otherwise
      type = Map.get(job, "type", "Full-Time")
      type == "Full-Time" &&
        Enum.any?(locations, fn location ->
          String.match?(location, ~r/United States/) || String.match?(location, ~r/Americas/)
        end) &&
        Enum.any?(locations, fn location ->
          String.match?(location, ~r/Remote/)
        end) &&
        (category == "Engineering" || category == "Analytics & Data Science" || category == "Site Reliability Engineering") &&
        String.match?(title, title_match)
    end)
    |> Enum.map(fn job ->
      {Map.get(job, "title"), "https://www.atlassian.com/company/careers/details/" <>  Integer.to_string(Map.get(job, "id"))}
    end)
  end
end
