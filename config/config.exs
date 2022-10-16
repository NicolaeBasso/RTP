import Config

config :stream_processor, SAS.Repo,
  database: "postgres",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5432

config :stream_processor, ecto_repos: [SAS.Repo]
# config :stream_processor, ecto_repos: [Repo]

# config :stream_processor, Repo,
#   database: "stream_processor",
#   username: "main_role",
#   password: "dcambur",
#   hostname: "localhost"
