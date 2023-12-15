defmodule Jobchecker.Jobs.Brex do
  def start([url, terms]) do
    Jobchecker.Helpers.get_greenhouse(url, ~r/United States/i, terms)
    |> Enum.map(fn {title, url} ->
      revised_url =  "https://www.brex.com/careers/" <> Enum.at(Regex.run(~r/gh_jid=(\d+)/, url), 1)
      {title, revised_url}
    end)
  end

  def test() do
    start(["https://boards-api.greenhouse.io/v1/boards/brex/jobs?content=true", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i]])
  end
end
