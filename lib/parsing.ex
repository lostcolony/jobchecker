defmodule Parsing do
  def get_html(%{url: url} = data) do
    body = HTTPoison.get!(url, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}], Map.get(data, :request_options, [])).body
    |> Floki.parse_document!()

    Map.put(data, :body, body)
  end

  def get_response_headers(%{url: url} = data) do
    Map.put(data, :headers, HTTPoison.get!(url, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}], Map.get(data, :request_options, [])).headers)
  end

  def get_cookies(%{url: url} = data) do
    headers = HTTPoison.get!(url).headers
    cookies = Enum.reduce(headers, [], fn ({key, val}, acc) ->
      case key do
        "Set-Cookie" -> [val | acc]
        _ -> acc
      end
    end)
    |> Enum.reverse
    |> Enum.join("; ")

    data
    |> Map.put(:cookie, cookies)
    |> Map.put(:headers, [{"Cookie", cookies} | Map.get(data, :headers, [])])
  end

  @spec get_json(%{:url => binary, optional(any) => any}) :: %{
          :decoded_json => any,
          :url => binary,
          optional(any) => any
        }
  def get_json(data = %{url: url}) do
    body = HTTPoison.get!(url, Map.get(data, :headers, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}]), Map.get(data, :request_options, [])).body
    |> JSON.decode!()

    Map.put(data, :decoded_json, body)
  end

  def post_json(data = %{url: url}) do
    decoded_json = HTTPoison.post!(url, Map.get(data, :post_body, ""), Map.get(data, :headers, [])).body |> JSON.decode!()

    Map.put(data, :decoded_json, decoded_json)
  end

  def follow_pages(data) do
    Process.sleep(500) #Just ensuring we put a little time in between our requests. No rush traversing these, be a better citizen
    data = post_json(data)
    {should_recurse, data} = data.next_page_function.(data)
    if should_recurse do
      follow_pages(data)
    else
      data
    end
  end

  def get_element(body, json_matcher) do
    Floki.find(body, json_matcher)
  end

  def get_element_from_html(data) do
    element = get_element(Map.get(data, :body), Map.get(data, :css_match))

    Map.put(data, :element, element)
  end

  def get_json_from_html(data = %{body: body, json_matcher: json_matcher}) do
    jobs_from_json = get_element(body, json_matcher)
    |> hd
    |> elem(2)
    |> JSON.decode!()

    Map.put(data, :decoded_json, jobs_from_json)
  end

  def get_data_from_json(json, match) do
    json
    |> Elixpath.query!(match)
  end

  def generate_title_and_url(data = %{decoded_json: decoded_json, title_match: title_match, url_match: url_match}) do
    titles_and_urls = Enum.zip(get_data_from_json(decoded_json, title_match), get_data_from_json(decoded_json, url_match))
    Map.put(data, :titles_and_urls, titles_and_urls)
  end

  def prefix_url(%{titles_and_urls: _, url_prefix: _} = data) do
    Map.update!(data, :titles_and_urls, fn titles_and_urls ->
      Enum.map(titles_and_urls, fn {title, id} ->
        id = if is_bitstring(id) do
          id
        else
          inspect(id)
        end
        {title, data.url_prefix <> id}
      end)
    end)
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
