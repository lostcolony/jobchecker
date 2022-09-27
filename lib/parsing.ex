defmodule Parsing do
  def get_html(url) do
    HTTPoison.get!(url).body
    |> Floki.parse_document!()
  end

  def get_json(url, params \\ []) do
    HTTPoison.get!(url, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}], params).body
    |> JSON.decode!()
  end


  def get_element(document, match) do
    Floki.find(document, match)
  end

  def get_json_from_html(document, css_matcher) do
    get_element(document, css_matcher)
    |> hd
    |> elem(2)
    |> JSON.decode!()
  end

  def get_data_from_json(json, match) do
    json
    |> Elixpath.query!(match)
  end
end
