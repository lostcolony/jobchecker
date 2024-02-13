defmodule Jobchecker.Jobs.SproutSocial do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/Remote US/i,terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/sproutsocial/jobs?content=true", Jobchecker.Helpers.default_filters])
  end
end
