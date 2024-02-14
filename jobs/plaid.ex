defmodule Jobchecker.Jobs.Plaid do
  def start([url, terms]) do
    Jobchecker.Helpers.get_html(url)
    |> Floki.find("script#__NEXT_DATA__")
    |> Floki.text([js: true])
    |> JSON.decode!()
    |> get_in(["props", "pageProps","fields","jobs", "Engineering", "jobs"])
    |> Enum.filter(fn x ->
      get_in(x, ["categories", "location"]) == "United States"
    end)
    |> Enum.map(fn x ->
      {Map.get(x, "text"), Map.get(x, "hostedUrl")}
    end)
    |> Jobchecker.Helpers.filter(terms)
  end

  def test() do
    start(["https://plaid.com/careers/openings/all-departments/all-locations/", Jobchecker.Helpers.default_filters ++ [~r/software engineer/i]])
  end
end
