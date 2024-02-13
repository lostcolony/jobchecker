defmodule Jobchecker.Jobs.Etsy do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find("div.job")
    |> Enum.map(fn x ->
      {Floki.find(x, "h3") |> Floki.text(), Floki.find(x, "a") |> Floki.attribute("href") |> to_string}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://careers.etsy.com/engineering", []])
  end
end
