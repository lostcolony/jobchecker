defmodule Jobchecker.Jobs.DBT do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/us - remote/i, terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/dbtlabsinc/jobs?content=true", Jobchecker.Helpers.default_filters])
  end
end
