defmodule Jobchecker.Jobs.Launchdarkly do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/Remote - US/i, terms)
  end

  def test() do
    start(["https://api.greenhouse.io/v1/boards/launchdarkly/jobs?content=true", []])
  end
end
