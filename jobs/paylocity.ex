defmodule Jobchecker.Jobs.Paylocity do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find(".listing-title")
    |> Enum.map(fn x ->
      {to_string(Floki.attribute(x, "aria-label")), to_string(Floki.attribute(x, "href"))}
    end)
    |> Jobchecker.Helpers.filter(terms)

  end

  def test() do
    start(["https://www.paylocity.com/careers/product-technology/?l=Remote%2C%20US", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
