defmodule Jobchecker.Jobs.Microsoft do
  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> get_in(["operationResult", "result", "jobs"])
    |> Enum.filter(fn job ->
      get_in(job, ["properties", "primaryLocation"])
      |> String.match?(~r/United States/i)
    end)
    |> Enum.map(fn job ->
      {Map.get(job, "title"), "https://jobs.careers.microsoft.com/global/en/job/" <> Map.get(job, "jobId")}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://gcsservices.careers.microsoft.com/search/api/v1/search?p=Software%20Engineering&rt=People%20Manager&et=Full-Time&ws=Up%20to%20100%%20work%20from%20home&l=en_us&pg=1&pgSz=20&o=Relevance&flt=true", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
