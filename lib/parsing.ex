defmodule Parsing do
  def get_html(url, params \\ []) do
    HTTPoison.get!(url, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}], params).body
    |> Floki.parse_document!()
  end

  def get_response_headers(url, params \\ []) do
    HTTPoison.get!(url, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}], params).headers
  end

  def get_json(url, params \\ []) do
    HTTPoison.get!(url, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}], params).body
    |> JSON.decode!()
  end

  def post_json(url, body, headers \\ []) do
    HTTPoison.post!(url, body, headers).body
    |> JSON.decode!()
  end

  def follow_pages(url, body, headers, next_page_function, count \\ nil) do

    Process.sleep(500) #Just ensuring we put a little time in between our requests. No rush traversing these, be a better citizen
    response = post_json(url, body, headers)
    {should_recurse, {url, body, jobs, total_count}} = next_page_function.(url, body, response, count)
    if should_recurse do
      next_set = follow_pages(url, JSON.encode!(body), headers, next_page_function, total_count)
      jobs ++ next_set
    else
      jobs
    end
  end

  def get_element(document, match) do
    Floki.find(document, match)
  end

  def get_element_from_html(document, css_matcher) do
    get_element(document, css_matcher)
    |> hd
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

  def generate_title_and_url(parsed_json, title_match, url_match) do
    Enum.zip(get_data_from_json(parsed_json, title_match), get_data_from_json(parsed_json, url_match))
  end

  def filter(titles_and_urls, []), do: titles_and_urls
  def filter(titles_and_urls, terms) do
    Enum.filter(titles_and_urls, fn {title, _} ->
      Enum.reduce(terms, false, fn (term, acc) ->
        String.match?(title, term) || acc
      end)
    end)
  end
end
