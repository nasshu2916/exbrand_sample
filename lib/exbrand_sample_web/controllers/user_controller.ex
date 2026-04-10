defmodule ExbrandSampleWeb.UserController do
  @moduledoc """
  controller から brand / Ecto schema を返す最小例。
  """

  use ExbrandSampleWeb, :controller

  alias ExbrandSample.Accounts
  alias ExbrandSampleWeb.UserJSON

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    json(conn, %{data: Enum.map(Accounts.list_users(), &UserJSON.show(%{user: &1}))})
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{data: UserJSON.show(%{user: user})})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errors_from_changeset(changeset)})
    end
  end

  defp errors_from_changeset(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, _opts} -> message end)
  end
end
