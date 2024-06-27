defmodule Jobchecker.Helpers do
  def default_filters do
    [
      ~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software|engineering.*lead|lead.*engineering|software.*lead|lead.*software)/i
    ]
  end

  def get_html(url) do
    get_html(url, [])
  end

  @spec get_html(binary, [{:recv_timeout, 10000} | {:timeout, 10000}]) :: [
          binary
          | {:comment, binary}
          | {:pi | binary, binary | list, list}
          | {:doctype, binary, binary, binary}
        ]
  def get_html(url, []) do
    get_html(url, [{:timeout, 10000}, {:recv_timeout, 10000}], 2)
  end

  def get_html(url, request_options) do
    get_html(url, request_options, 2)
  end

  defp get_html(url, request_options = [{:timeout, 10000}, {:recv_timeout, 10000}], count) do
    try do
      HTTPoison.get!(
        url,
        [
          {"User-Agent",
           "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}
        ],
        request_options
      ).body
      |> Floki.parse_document!()
    rescue
      err ->
        if count > 0 do
          :timer.sleep(1234 * (3 - count))
          get_html(url, request_options, count - 1)
        else
          reraise(err, __STACKTRACE__)
        end
    end
  end

  def get_json(url) do
    _get_json(url, "gzip, deflate, br, zstd")
    |> :zlib.gunzip()
    |> JSON.decode!()
  end

  def get_json(url, encoding) do
    _get_json(url, encoding)
    |> JSON.decode!()
  end

  def _get_json(url, encoding) do
    HTTPoison.get!(
      url,
      [
        {"User-Agent",
         "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:127.0) Gecko/20100101 Firefox/127.0"},
        {"Accept",
         "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8"},
        {"Accept-Language", "en-US,en;q=0.5"},
        {"Accept-Encoding", encoding},
        {"Connection", "keep-alive"},
        {"Upgrade-Insecure-Requests", "1"},
        {"Sec-Fetch-Dest", "document"},
        {"Sec-Fetch-Mode", "navigate"},
        {"Sec-Fetch-Site", "cross-site"},
        {"Priority", "u=1"},
        {"Pragma", "no-cache"},
        {"Cache-Control", "no-cache"}
      ],
      recv_timeout: 10000
    ).body
  end

  @spec get_greenhouse(any(), any(), any()) :: none()
  def get_greenhouse(url, location_regex, terms) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("jobs")
    |> Enum.filter(fn job ->
      get_in(job, ["location", "name"]) |> String.match?(location_regex)
    end)
    |> Enum.map(fn job ->
      {Map.get(job, "title"), Map.get(job, "absolute_url")}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  # TODO: Refactor to take a map instead of a tuple
  def filter(titles_and_urls, []), do: titles_and_urls

  def filter(titles_and_urls, terms) do
    Enum.filter(
      titles_and_urls,
      fn
        {title, _} ->
          Enum.reduce(terms, false, fn term, acc ->
            String.match?(title, term) || acc
          end)

        {title, _, _} ->
          Enum.reduce(terms, false, fn term, acc ->
            String.match?(title, term) || acc
          end)
      end
    )
  end
end
