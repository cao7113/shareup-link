import Config

config :kaffy,
  otp_app: :slink,
  ecto_repo: Slink.Repo,
  router: SlinkWeb.Router
