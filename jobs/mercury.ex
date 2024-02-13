defmodule Jobchecker.Jobs.Mercury do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/remote/i, terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/mercury/jobs?content=true", Jobchecker.Helpers.default_filters])
  end
end
