defmodule Jobchecker.Jobs.Facebook do
  def start([url, terms]) do
    HTTPoison.post!(url, "av=108696208958606&__user=0&__a=1&__req=2&__hs=19829.BP%3ADEFAULT.2.0..0.0&dpr=1&__ccg=EXCELLENT&__rev=1012800490&__s=tf7yqe%3Aj1vurk%3Abalzyn&__hsi=7358299205909561825&__dyn=7xeUmwkHg7ebwKBAg5S1Dxu13wqovzEdEc8uxa1twKzobo19oe8hwem0nCq1ewbWbwbG782Cwooa81VohwnU14E9k2C220qu0H8jw9S6oG0OU5a1qw8W1uwa-7U1bobodEGdxa0YU2ZwrU6C0P82Sw8i6E3ewt87u&__csr=&fb_dtsg=NAcM-9xC4jTJlpdcwedIJBaqx02a8SVloBB2YP_hmITIYMcdHK3QjMg%3A18%3A1713235862&jazoest=25403&lsd=SfsX_63dLS_xi8mJHLjL8o&__spin_r=1012800490&__spin_b=trunk&__spin_t=1713237540&__jssesw=1&fb_api_caller_class=RelayModern&fb_api_req_friendly_name=CareersJobSearchResultsQuery&variables=%7B%22search_input%22%3A%7B%22q%22%3A%22%22%2C%22divisions%22%3A%5B%5D%2C%22offices%22%3A%5B%5D%2C%22roles%22%3A%5B%5D%2C%22leadership_levels%22%3A%5B%22People%20Manager%22%5D%2C%22saved_jobs%22%3A%5B%5D%2C%22saved_searches%22%3A%5B%5D%2C%22sub_teams%22%3A%5B%5D%2C%22teams%22%3A%5B%5D%2C%22is_leadership%22%3Afalse%2C%22is_remote_only%22%3Atrue%2C%22sort_by_new%22%3Afalse%2C%22page%22%3A1%2C%22results_per_page%22%3Anull%7D%7D&server_timestamps=true&doc_id=9114524511922157",[
      {"Host", "www.metacareers.com"},
      {"User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0"},
      {"Accept", "*/*"},
      {"Accept-Language", "en-US,en;q=0.5"},
      {"Accept-Encoding", "json"},
      {"Referer", "https://www.metacareers.com/jobs/?is_remote_only=true&leadership_levels[0]=People%20Manager"},
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"X-FB-Friendly-Name", "CareersJobSearchResultsQuery"},
      {"X-FB-LSD", "SfsX_63dLS_xi8mJHLjL8o"},
      {"X-ASBD-ID", "129477"},
      {"Content-Length", "1104"},
      {"Origin", "https://www.metacareers.com"},
      {"Alt-Used", "www.metacareers.com"},
      {"Connection", "keep-alive"},
      {"Sec-Fetch-Dest", "empty"},
      {"Sec-Fetch-Mode", "cors"},
      {"Sec-Fetch-Site", "same-origin"},
      {"Pragma", "no-cache"},
      {"Cache-Control", "no-cache"},
      {"TE", "trailers"}
    ]).body
    |> JSON.decode!()
    |> get_in(["data", "job_search"])
    |> Enum.map(fn x ->
      {Map.get(x, "title"), "https://www.metacareers.com/jobs/" <> Map.get(x, "id")}
    end)
  end

  def test() do
    start(["https://www.metacareers.com/graphql", [~r/(engineering.*manager|manager.*engineering|software.*manager|manager.*software|engineering.*director|director.*engineering|software.*director|director.*software)/i]])
  end
end
