defmodule Jobchecker do
  import Parsing
  @moduledoc """
  Documentation for `Jobchecker`.
  """

  def init({company, steps, filters}, return_pid) do
    jobs = execute(steps)
    |> filter(filters)
    |> Enum.uniq() #At least one job board allows for duplicates. This causes false positives in detecting new jobs.

    send(return_pid, {company, jobs})
  end

  @spec execute(any) :: any
  def execute(steps), do: execute(steps, nil)

  def execute([], data), do: data.titles_and_urls
  def execute([command | remaining], data) do
    next_data =
      case {command, data} do
        {{:load_data, map}, nil} -> map
        {{:load_data, map}, data} when is_map(data) -> Enum.into(map, data)
        {:get_response_headers, %{url: _url}} -> get_response_headers(data)
        {:get_html, %{url: _url}} -> get_html(data) #Optionally request_options
        {:get_json_from_html, %{json_matcher: _, body: _}} -> get_json_from_html(data)
        {:get_json, %{url: _url}} -> get_json(data) #Optionally request_options
        {:post_json, %{url: _}} -> follow_pages(data) #Optionally body, request_options, next_page_function
        {:generate_title_and_url_from_json, %{title_match: _, url_match: _, decoded_json: _}} -> generate_title_and_url(data)
        {{:eval, to_eval}, data} when is_function(to_eval)-> to_eval.(data)
        {:get_element_from_html, data} -> get_element_from_html(data)
        {:prefix_url, data} -> prefix_url(data)
        {:inspect, data} ->
          IO.inspect(data)
          data
        _ -> raise "Unrecognized command #{command} in config"
    end
    execute(remaining, next_data)
  end
  def execute(other, data) do
    IO.inspect({other, data})
  end
end
