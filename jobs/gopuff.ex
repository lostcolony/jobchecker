defmodule Jobchecker.Jobs.Gopuff do
  def start([url, terms]) do
    jobs = Jobchecker.Helpers.get_json(url, "application/json")
    |> Enum.filter(fn x -> Map.get(x, "title") == "Tech, Product, & Design" end)

    case jobs do
      [] -> []
      [items|_] ->
        items
        |> Map.get("postings")
        |> Enum.map(fn x -> {Map.get(x, "text"), Map.get(x, "hostedUrl")} end)
        |> Jobchecker.Helpers.filter(terms)
    end
  end

  def test() do
    start(["https://api.lever.co/v0/postings/gopuff?mode=json&group=department", [~r/(manager|director)/i]])
  end
end
