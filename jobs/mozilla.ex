defmodule Jobchecker.Jobs.Mozilla do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/Remote US/i, terms)
  end


  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/mozilla/jobs?content=true", [~r/(manager|director)/i]])
  end
end
