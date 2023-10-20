defmodule Jobchecker.Jobs.Airbnb do
  def start([url, terms]) do
    jobs = Jobchecker.Helpers.get_json(url)
    |> Map.get("jobs")

    jobs = Enum.filter(jobs, fn x ->
      Map.get(x, "locations")
      |> Enum.any?(fn location -> Map.get(location, "locationName") == "United States" end)
    end)

    titles = Enum.map(jobs, fn x -> Map.get(x, "title") end)

    urls = Enum.map(jobs, fn x -> "https://careers.airbnb.com/positions/" <> Integer.to_string(Map.get(x, "id")) end)

    Enum.zip(titles, urls)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://careers.airbnb.com/wp-admin/admin-ajax.php?action=fetch_greenhouse_jobs&which-board=airbnb&strip-empty=true", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
