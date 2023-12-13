defmodule Jobchecker.Jobs.Coreweave do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/Remote/, terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/coreweave/jobs?content=true", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
