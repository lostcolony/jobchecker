defmodule Jobchecker.Helpers do
  def get_html(url, []) do
    get_html(url, [{:timeout, 10000}, {:recv_timeout, 10000}])
  end
  def get_html(url, request_options = [{:timeout, 10000}, {:recv_timeout, 10000}]) do
    HTTPoison.get!(url, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}], request_options).body
    |> Floki.parse_document!()
  end

  #TODO: Refactor to take a map instead of a tuple
  def filter(titles_and_urls, []), do: titles_and_urls
  def filter(titles_and_urls, terms) do
    Enum.filter(titles_and_urls,
    fn {title, _} ->
      Enum.reduce(terms, false, fn (term, acc) ->
        String.match?(title, term) || acc
      end)
    {title, _, _} ->
      Enum.reduce(terms, false, fn (term, acc) ->
        String.match?(title, term) || acc
      end)
    end)
  end

end
