defmodule Jobchecker.Jobs.Instacart do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/United States - Remote/i, terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/Instacart/jobs?content=true", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
