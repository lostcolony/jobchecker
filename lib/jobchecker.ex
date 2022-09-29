defmodule Jobchecker do
  import Parsing
  @moduledoc """
  Documentation for `Jobchecker`.
  """

  def init({company, steps, filters}, return_pid) do
    jobs = recurse(steps)
    |> filter(filters)
    |> Enum.uniq() #At least one job board allows for duplicates. This causes false positives in detecting new jobs.

    send(return_pid, {company, jobs})
  end

  def recurse(steps), do: recurse(steps, nil)

  def recurse([], data), do: data
  def recurse([command | remaining], data) do
    next_data =
      case command do
        {:get_response_headers, {url, params}} -> get_response_headers(url, params)
        {:get_response_headers, url} -> get_response_headers(url)
        {:get_html, {url, params} } -> get_html(url, params)
        {:get_html, url} -> get_html(url)
        :get_html -> get_html(data)
        {:get_json_from_html, matcher} -> get_json_from_html(data, matcher)
        {:get_json, {url, params}} -> get_json(url, params)
        {:get_json, url} -> get_json(url)
        :get_json -> get_json(data)
        {:post_json, url, body, headers, next_page_function} -> follow_pages(url, body, headers, next_page_function)
        {:post_json_with_carried_headers, url, body, next_page_function} -> follow_pages(url, body, data, next_page_function)
        {:generate_title_and_url_from_json, title_match, url_match} -> generate_title_and_url(data, title_match, url_match)
        {:eval, to_eval} -> to_eval.(data)
        {:get_element_from_html, element} -> get_element_from_html(data, element)
        _ -> raise "Unrecognized command #{command} in config"
    end
    recurse(remaining, next_data)
  end
end
