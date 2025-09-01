defmodule Ceres.Repo do
  use Ecto.Repo,
    otp_app: :ceres,
    adapter: Ecto.Adapters.Postgres
end
