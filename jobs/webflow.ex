defmodule Jobchecker.Jobs.Webflow do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/U\.S\. Remote/i, terms)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/webflow/jobs?content=true", Jobchecker.Helpers.default_filters])
  end
end
