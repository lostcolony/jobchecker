defmodule Jobchecker.Jobs.Wish do
  def start([url, terms]) do
    Jobchecker.Helpers.get_json(url)
    |> Map.get("content")
    |> Enum.filter(fn x ->
      get_in(x, ["location", "remote"]) && get_in(x, ["location", "country"]) == "us"
    end)
    |> Enum.map(fn x ->
      {Map.get(x, "name"), Map.get(x, "ref")}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://api.smartrecruiters.com/v1/companies/Wish/postings/?offset=0&limit=100", Jobchecker.Helpers.default_filters])
  end
end
