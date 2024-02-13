defmodule Jobchecker.Jobs.Samsara do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/Remote - US/i, terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/samsara/jobs?content=true", Jobchecker.Helpers.default_filters])
  end
end
