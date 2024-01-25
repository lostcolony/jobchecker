defmodule Jobchecker.Jobs.Amperity do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find(".styles_jobs_list__2sWgh > a")
    |> Enum.map(fn x ->
      job_info = hd(Floki.find(x, "h5"))
      {Floki.text(job_info), "https://amperity.com" <> to_string(Floki.attribute(x, "href"))}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://amperity.com/careers?dept=Engineering&loc=Remote", []])
  end
end
