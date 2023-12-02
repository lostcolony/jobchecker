defmodule Jobchecker.Jobs.Docusign do
  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("jobs")
    |> Enum.map(fn job ->
      data = Map.get(job, "data")
      {Map.get(data, "title"), "https://careers.docusign.com/jobs/" <> to_string(Map.get(data, "slug"))}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end


  def test() do
    start(["https://careers.docusign.com/api/jobs?page=1&locations=Remote,,United%20States&categories=Product%20Development&tags1=Regular&sortBy=relevance&descending=false&internal=false", []])
  end
end
