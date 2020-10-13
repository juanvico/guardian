import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
db_host = System.fetch_env!("DB_HOST")
db_instance = System.fetch_env!("DB_INSTANCE")
db_user = System.fetch_env!("DB_USER")
db_password = System.fetch_env!("DB_PASSWORD")

config :guardian, GuardianWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base

config :guardian, Guardian.Repo,
  hostname: db_host,
  username: db_user,
  password: db_password,
  database: db_instance,
  pool_size: 15,
  show_sensitive_data_on_connection_error: true
