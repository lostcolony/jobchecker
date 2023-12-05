defmodule Jobchecker.Jobs.Amperity do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find(".styles_job__5_c31")
    |> Enum.filter(fn x ->
      Floki.find(x, "p") |> Floki.text() |> String.match?(~r/remote/i)
    end)
    |> Enum.map(fn x ->
      job_info = hd(Floki.find(x, "a"))
      {Floki.text(job_info), "https://amperity.com" <> to_string(Floki.attribute(job_info, "href"))}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://amperity.com/careers?dept=Engineering&loc=Remote", []])
  end
end
