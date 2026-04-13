defmodule ExbrandSampleWeb.UserPageControllerTest do
  use ExbrandSampleWeb.ConnCase, async: true

  alias ExbrandSample.Accounts
  alias ExbrandSample.Accounts.Types
  alias ExbrandSample.Repo

  test "GET /users shows a user list", %{conn: conn} do
    assert {:ok, _user} =
             Accounts.create_user(%{
               "user_id" => 1001,
               "email" => "test_user@example.com",
               "nickname" => "test_user",
               "status" => "active"
             })

    conn = get(conn, ~p"/users")
    html = html_response(conn, 200)

    assert html =~ "ユーザ一覧"
    assert html =~ "test_user"
    assert html =~ "test_user@example.com"
    assert html =~ "詳細"
    assert html =~ "編集"
  end

  test "GET /users shows an empty state", %{conn: conn} do
    conn = get(conn, ~p"/users")

    assert html_response(conn, 200) =~ "ユーザはまだ登録されていません。"
  end

  test "GET /users/:user_id shows one user", %{conn: conn} do
    assert {:ok, _user} =
             Accounts.create_user(%{
               "user_id" => 1001,
               "email" => "test_user@example.com",
               "nickname" => "test_user",
               "status" => "active"
             })

    conn = get(conn, ~p"/users/1001")
    html = html_response(conn, 200)

    assert html =~ "User ID"
    assert html =~ "1001"
    assert html =~ "test_user@example.com"
    assert html =~ "ユーザを削除"
  end

  test "GET /users/new shows the registration form", %{conn: conn} do
    conn = get(conn, ~p"/users/new")

    html = html_response(conn, 200)
    assert html =~ "ユーザ登録"
    assert html =~ "user-form"
  end

  test "POST /users creates a user and redirects to show page", %{conn: conn} do
    conn =
      post(conn, ~p"/users", %{
        "user" => %{
          "user_id" => "1002",
          "email" => "user@example.com",
          "nickname" => "portal-user",
          "status" => "active"
        }
      })

    assert redirected_to(conn) == "/users/1002"

    user = Repo.one!(ExbrandSample.Accounts.User)
    assert Types.UserID.unwrap(user.user_id) == 1002
    assert Types.Email.unwrap(user.email) == "user@example.com"
    assert Types.Nickname.unwrap(user.nickname) == "portal-user"
    assert user.status == :active
  end

  test "GET /users/:user_id/edit shows the edit form", %{conn: conn} do
    assert {:ok, _user} =
             Accounts.create_user(%{
               "user_id" => 1002,
               "email" => "user@example.com",
               "nickname" => "portal-user",
               "status" => "active"
             })

    conn = get(conn, ~p"/users/1002/edit")
    html = html_response(conn, 200)

    assert html =~ "ユーザ編集"
    assert html =~ "user-form"
  end

  test "PUT /users/:user_id updates a user", %{conn: conn} do
    assert {:ok, _user} =
             Accounts.create_user(%{
               "user_id" => 1002,
               "email" => "user@example.com",
               "nickname" => "portal-user",
               "status" => "invited"
             })

    conn =
      put(conn, ~p"/users/1002", %{
        "user" => %{
          "user_id" => "1003",
          "email" => "updated@example.com",
          "nickname" => "updated-user",
          "status" => "active"
        }
      })

    assert redirected_to(conn) == "/users/1003"

    user = Accounts.get_user_by_user_id!(1003)
    assert Types.Email.unwrap(user.email) == "updated@example.com"
    assert Types.Nickname.unwrap(user.nickname) == "updated-user"
    assert user.status == :active
  end

  test "DELETE /users/:user_id deletes a user", %{conn: conn} do
    assert {:ok, _user} =
             Accounts.create_user(%{
               "user_id" => 1004,
               "email" => "delete@example.com",
               "nickname" => "delete-user",
               "status" => "active"
             })

    conn = delete(conn, ~p"/users/1004")

    assert redirected_to(conn) == "/users"
    assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_by_user_id!(1004) end
  end

  test "POST /users re-renders the form on validation errors", %{conn: conn} do
    conn =
      post(conn, ~p"/users", %{
        "user" => %{
          "user_id" => "-1",
          "email" => "invalid",
          "nickname" => "no",
          "status" => "invited"
        }
      })

    html = html_response(conn, 422)
    assert html =~ "ユーザ登録"
    assert html =~ "is invalid"
  end
end
