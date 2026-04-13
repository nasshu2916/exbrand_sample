defmodule ExbrandSampleWeb.UserController do
  @moduledoc """
  controller から brand / Ecto schema を返す最小例。
  """

  use ExbrandSampleWeb, :controller

  alias ExbrandSample.Accounts
  alias ExbrandSampleWeb.UserJSON

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    render_users(conn, Accounts.list_users())
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"user_id" => user_id}) do
    user_id
    |> Accounts.get_user_by_user_id!()
    |> then(&render_user(conn, &1))
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render_user(user)

      {:error, changeset} ->
        render_changeset_error(conn, changeset)
    end
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"user_id" => user_id} = params) do
    case Accounts.update_user_by_user_id(user_id, Map.delete(params, "user_id")) do
      {:ok, updated_user} ->
        render_user(conn, updated_user)

      {:error, changeset} ->
        render_changeset_error(conn, changeset)

      :error ->
        raise Ecto.NoResultsError, queryable: ExbrandSample.Accounts.User
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"user_id" => user_id}) do
    case Accounts.delete_user_by_user_id(user_id) do
      {:ok, _deleted_user} -> send_resp(conn, :no_content, "")
      :error -> raise Ecto.NoResultsError, queryable: ExbrandSample.Accounts.User
      {:error, _changeset} -> raise Ecto.NoResultsError, queryable: ExbrandSample.Accounts.User
    end
  end

  defp errors_from_changeset(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, _opts} -> message end)
  end

  defp render_users(conn, users) do
    json(conn, %{data: Enum.map(users, &UserJSON.show(%{user: &1}))})
  end

  defp render_user(conn, user) do
    json(conn, %{data: UserJSON.show(%{user: user})})
  end

  defp render_changeset_error(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: errors_from_changeset(changeset)})
  end
end
