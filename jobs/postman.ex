defmodule Jobchecker.Jobs.Postman do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find("a.BaseLinkStyles-sc-7vt82q-0")
    |> tl()
    |> Enum.take_every(2)
    |> Enum.filter(fn x ->
      Floki.attribute(x, "href") |> to_string() |> String.match?(~r/careers/)
    end)
    |> Enum.map(fn x ->
      {Floki.text(x), "https://www.postman.com" <> (Floki.attribute(x, "href") |> to_string())}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://www.postman.com/company/careers/open-positions/", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
