defmodule Jobchecker.Jobs.Airbnb do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/United States/i, terms)
    # |> Enum.map(fn {title, url} ->
    #   {title, String.replace(url, ~r/\?gh_jid=[.*]/, "")}
    # end)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/airbnb/jobs?content=true", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
