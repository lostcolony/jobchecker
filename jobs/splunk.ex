defmodule Jobchecker.Jobs.Splunk do
  def start([url, terms]) do
    HTTPoison.get!(url, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}], []).body
      |> JSON.decode!()
      |> Map.get("careersList")
      |> Enum.filter(fn x -> String.match?(Map.get(x, "jobTitle"), ~r/remote/i) end)
      |> Enum.map(fn x -> {Map.get(x, "jobTitle"), "https://www.splunk.com" <> Map.get(x, "url")} end)
      |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://www.splunk.com/api/bin/careers/jobs", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
