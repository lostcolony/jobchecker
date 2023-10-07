defmodule Jobchecker.Jobs.Remoterocketship do

  def start(url) do
    uri = URI.parse(url)
    body = HTTPoison.get!(url, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}], []).body
    supabase_url = uri.scheme <> "://" <> uri.host <> hd(Regex.run(~r/\/_next\/static\/chunks\/pages\/_app\-[[:alnum:]]+\.js/, body))
    supabase_info = HTTPoison.get!(supabase_url, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"}], []).body
    supabase_url = Enum.at(Regex.run(~r/supabaseUrl:e="([^"]*)"/, supabase_info), 1)
    supabase_token = Enum.at(Regex.run(~r/supabaseKey:t="([^"]*)"/, supabase_info), 1)
    supabase_url = supabase_url <> "/rest/v1/jobOpening?select=*%2Ccompany%21inner%28*%29&order=isPromoted.desc.nullslast%2Ccreated_at.desc.nullslast&company.employeeRange=in.%28%2251%2C200%22%2C%22201%2C500%22%2C%22501%2C1000%22%2C%221001%2C5000%22%2C%225001%2C10000%22%2C%2210001%2C%22%29&or=%28categorizedJobTitle.in.%28Engineering+Manager%29%29&or=%28location.in.%28United+States%2CWorldwide%2CNorth+America%29%2ClocationRegion.in.%28%29%29&limit=20&offset=0"

    HTTPoison.get!(supabase_url, [{"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0"},
                         {"apikey", supabase_token}, {"authorization", "Bearer " <> supabase_token}], []).body
      |> JSON.decode!()
      |> Enum.map(fn %{"url" => url, "roleTitle" => title, "company" => %{"name" => company}} ->
        company = company
        |> String.replace("\\u002d", "-")
        |> String.replace("–", "-") #This is a unicode em dash. Ugh
        |> String.replace("™", "TM")

        title = title
        |> String.replace("\\u002d", "-")
        |> String.replace("–", "-") #This is a unicode em dash. Ugh
        |> String.replace("™", "TM")

        {company <> " - " <> title, url}
      end)

  end

end
