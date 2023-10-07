defmodule Jobchecker.Jobs.Linkedin do

  def retrieve([comment: ""], _) do [] end
  def retrieve(html, filter) do

    json = Floki.find(html, "a.base-card__full-link")


    titles = Enum.map(Floki.find(json, ".sr-only"), fn x -> String.trim(Floki.text(x)) end)
    companies = Floki.find(html, "a.hidden-nested-link")
    urls = Floki.attribute(json, "href")



    titles_urls_companies = Enum.zip([titles, urls, companies])
    |> Jobchecker.Helpers.filter(filter)

    stream = Task.async_stream(titles_urls_companies, fn ({title, url, company}) ->
      html = Jobchecker.Helpers.get_html(url, [])

      title = title
      # |> String.replace("\\u002d", "-")
      # |> String.replace("–", "-") #This is a unicode em dash. Ugh
      # |> String.replace("™", "TM")

      company = company
        |> Floki.text()
        |> String.trim()
        # |> String.replace("\\u002d", "-")
        # |> String.replace("–", "-") #This is a unicode em dash. Ugh
        # |> String.replace("™", "TM")

      new_url = html
      |> Floki.find("code#applyUrl")

      return_url = case new_url do
        [] ->
          parsed = URI.parse(url)
          parsed.scheme <> "://" <> parsed.host <> parsed.path
        _ ->
          new_url
            |> hd()
            |> elem(2)
            |> hd()
            |> elem(1)
            |> URI.parse()
            |> Map.get(:query)
            |> URI.query_decoder()
            |> Enum.find(nil, fn x -> x end)
            |> elem(1)
            |> String.replace("\\u002d", "-")
      end



      {company <> " - " <> title, return_url}
    end, [{:timeout, 10000}])

    Enum.map(stream, fn {:ok, result} -> result end)
  end


  def recurse(url, count, filter) do
    case retrieve(Jobchecker.Helpers.get_html(url <> "&start=" <> Integer.to_string(count), []), filter) do
      [] -> []
      a -> a ++ recurse(url, count + 25, filter)
    end
  end

  def start([url, filter]) do
    recurse(url, 0, filter)
  end

end
