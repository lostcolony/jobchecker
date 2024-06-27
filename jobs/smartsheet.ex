defmodule Jobchecker.Jobs.Smartsheet do
  def start([url, terms]) do
    entries = Jobchecker.Helpers.get_html(url)
    |> Floki.find(".views-field-title")
    |> Floki.find("a")

    case entries do
      [_ | entries] ->

        urls = entries |> Floki.attribute("href")

        titles = entries |> Enum.map(fn x -> Floki.text(x) end)

        Enum.zip([titles, urls])
        |> Jobchecker.Helpers.filter(terms)
      [] -> []
    end

  end


  def test() do
    start(["https://www.smartsheet.com/careers-list?location=-REMOTE%2C+USA-&department=Engineering+-+Developers&position=", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
