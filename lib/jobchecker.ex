defmodule Jobchecker do
  import Parsing
  @moduledoc """
  Documentation for `Jobchecker`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Jobchecker.hello()
      :world

  """


  def test() do
    # parsed_json =
    #   get_html("https://www.brex.com/careers")
    #   |> get_json_from_html("script#__NEXT_DATA__")
    # Enum.zip(get_data_from_json(parsed_json, ~S/.."jobs".."title"/), get_data_from_json(parsed_json, ~S/.."jobs".."absolute_url"/))

    # parsed_json = get_json("https://jobs.netflix.com/api/search", [params: [location: "Remote, United States"]])
    # Enum.zip(get_data_from_json(parsed_json, ~S/.."text"/), Enum.map(get_data_from_json(parsed_json, ~S/.."external_id"/), fn x -> "https://jobs.netflix.com/jobs/" <> x end))

  end
end
