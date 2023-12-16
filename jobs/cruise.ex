defmodule Jobchecker.Jobs.Cruise do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/US Remote/i, terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/cruise/jobs?content=true", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
