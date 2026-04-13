defmodule ExbrandSampleWeb.UserJSON do
  @moduledoc """
  Phoenix 側へ返す JSON payload を組み立てる。
  """

  alias ExbrandSample.Accounts.User

  @spec show(%{user: User.t()}) :: map()
  def show(%{user: user}) do
    %{
      id: Phoenix.Param.to_param(user.user_id),
      email: user.email,
      email_html: user.email |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary(),
      nickname: user.nickname,
      status: user.status
    }
  end
end
