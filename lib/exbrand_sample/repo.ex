defmodule ExbrandSample.Repo do
  use Ecto.Repo,
    otp_app: :exbrand_sample,
    adapter: Ecto.Adapters.SQLite3
end
