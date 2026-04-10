defmodule ExbrandSample.Accounts.Types do
  @moduledoc """
  Accounts feature で使う brand 定義。
  """

  use ExBrand

  defbrand(UserID, {:integer, validate: &(&1 > 0), error: :must_be_positive})

  defbrand(
    Email,
    {:string, validate: &String.contains?(&1, "@"), error: :invalid_email, name: "Email Address"}
  )

  defbrand(
    Nickname,
    {:string, validate: &(String.length(&1) >= 3), error: :too_short}
  )
end
