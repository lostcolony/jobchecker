import Config

config :mnesia, dir: '.mnesia/#{Mix.env}/#{node()}'
