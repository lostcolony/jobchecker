import Config

config :mnesia, dir: '.mnesia/#{Mix.env}/#{node()}'
config :jobchecker, file: "jobs.exs", email_password: System.get_env("email_password"), from: System.get_env("from_email"), to: System.get_env("to_email"), relay: System.get_env("smtp_relay"), port: elem(Integer.parse(System.get_env("smtp_port")),0)
