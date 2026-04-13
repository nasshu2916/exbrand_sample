defmodule ExbrandSampleWeb.UserPageController do
  use ExbrandSampleWeb, :controller

  import Phoenix.Component, only: [to_form: 1]

  alias ExbrandSample.Accounts
  alias ExbrandSample.Accounts.User

  def index(conn, _params) do
    render(conn, :index, users: Accounts.list_users())
  end

  def show(conn, %{"user_id" => user_id}) do
    render(conn, :show, user: load_user!(user_id))
  end

  def new(conn, _params) do
    render(conn, :new, form: to_form(Accounts.change_user(%User{})))
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "ユーザを登録しました。")
        |> redirect(to: ~p"/users/#{user.user_id}")

      {:error, changeset} ->
        render_form_error(conn, :new, changeset)
    end
  end

  def edit(conn, %{"user_id" => user_id}) do
    user = load_user!(user_id)
    render(conn, :edit, user: user, form: to_form(Accounts.change_user(user)))
  end

  def update(conn, %{"user_id" => user_id, "user" => user_params}) do
    case Accounts.update_user_by_user_id(user_id, user_params) do
      {:ok, updated_user} ->
        conn
        |> put_flash(:info, "ユーザを更新しました。")
        |> redirect(to: ~p"/users/#{updated_user.user_id}")

      {:error, changeset} ->
        render_form_error(conn, :edit, changeset, user: load_user!(user_id))

      :error ->
        raise Ecto.NoResultsError, queryable: User
    end
  end

  def delete(conn, %{"user_id" => user_id}) do
    case Accounts.delete_user_by_user_id(user_id) do
      {:ok, _deleted_user} ->
        conn
        |> put_flash(:info, "ユーザを削除しました。")
        |> redirect(to: ~p"/users")

      :error ->
        raise Ecto.NoResultsError, queryable: User

      {:error, _changeset} ->
        raise Ecto.NoResultsError, queryable: User
    end
  end

  defp load_user!(user_id), do: Accounts.get_user_by_user_id!(user_id)

  defp render_form_error(conn, template, changeset, extra_assigns \\ []) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(template, Keyword.merge([form: to_form(changeset)], extra_assigns))
  end
end
