defmodule Jobchecker.Jobs.Mongodb do

  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/United States/i, terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/mongodb/jobs?content=true", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
