fn() ->
  html = Helpers.get_html("https://www.brex.com/careers", [])
  json = Floki.find(html, "script#__NEXT_DATA__")
    |> hd
    |> elem(2)
    |> JSON.decode!()

  jobs = Enum.zip(Elixpath.query!(json, ~S/.."departments".*."name"/), Elixpath.query!(json, ~S/.."jobs"/))
  |> Enum.find(nil, fn x -> elem(x, 0) == "Engineering" end)
  |> elem(1)
  |> Enum.filter(fn x -> Kernel.get_in(x, ["location", "name"]) == "Brazil" end)

  Enum.zip(Elixpath.query!(jobs, ~S/.."title"/), Elixpath.query!(jobs, ~S/.."absolute_url"/))
  |> Helpers.filter([~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software)/i])

end
