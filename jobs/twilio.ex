defmodule Jobchecker.Jobs.Twilio do
  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("offices")
    |> Enum.filter(fn x -> Map.get(x, "name") == "Remote - US"  end)
    |> hd()
    |> Map.get("departments")
    |> Enum.filter(fn x -> Map.get(x, "name") == "Engineering" end)
    |> hd()
    |> Map.get("jobs")
    |> Enum.map(fn x -> {Map.get(x, "title"), Map.get(x, "absolute_url")} end)
    |> Jobchecker.Helpers.filter(terms)
  end


  def test() do
    start(["https://www.twilio.com/en-us/company/jobs/jcr:content/root/global-main/section/column_control/column-0/jobs_component.jobs.json", [~r/(manager|director)/i]])
  end
end
