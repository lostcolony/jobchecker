defmodule Jobchecker.Jobs.Madhive do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/United States/i, terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/madhive/jobs?content=true", Jobchecker.Helpers.default_filters])
  end
end
