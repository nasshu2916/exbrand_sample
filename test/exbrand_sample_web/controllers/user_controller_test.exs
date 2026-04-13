defmodule ExbrandSampleWeb.UserControllerTest do
  use ExbrandSampleWeb.ConnCase, async: true

  alias ExbrandSample.Accounts

  test "GET /api/users returns persisted users", %{conn: conn} do
    assert {:ok, _user} =
             Accounts.create_user(%{
               "user_id" => 1001,
               "email" => "test_user@example.com",
               "nickname" => "test_user",
               "status" => "active"
             })

    conn = get(conn, ~p"/api/users")

    assert %{
             "data" => [
               %{
                 "id" => "1001",
                 "email" => "test_user@example.com",
                 "email_html" => "test_user@example.com",
                 "nickname" => "test_user",
                 "status" => "active"
               }
             ]
           } = json_response(conn, 200)
  end

  test "GET /api/users/:user_id returns one user", %{conn: conn} do
    assert {:ok, _user} =
             Accounts.create_user(%{
               "user_id" => 1001,
               "email" => "test_user@example.com",
               "nickname" => "test_user",
               "status" => "active"
             })

    conn = get(conn, ~p"/api/users/1001")

    assert %{
             "data" => %{
               "id" => "1001",
               "email" => "test_user@example.com",
               "nickname" => "test_user",
               "status" => "active"
             }
           } = json_response(conn, 200)
  end

  test "POST /api/users persists a branded user", %{conn: conn} do
    conn =
      post(conn, ~p"/api/users", %{
        "user_id" => 1002,
        "email" => "user@example.com",
        "nickname" => "portal-user"
      })

    assert %{
             "data" => %{
               "id" => "1002",
               "email" => "user@example.com",
               "email_html" => "user@example.com",
               "nickname" => "portal-user",
               "status" => "invited"
             }
           } = json_response(conn, 201)
  end

  test "PUT /api/users/:user_id updates a user", %{conn: conn} do
    assert {:ok, _user} =
             Accounts.create_user(%{
               "user_id" => 1002,
               "email" => "user@example.com",
               "nickname" => "portal-user",
               "status" => "invited"
             })

    conn =
      put(conn, ~p"/api/users/1002", %{
        "email" => "updated@example.com",
        "nickname" => "updated-user",
        "status" => "active"
      })

    assert %{
             "data" => %{
               "id" => "1002",
               "email" => "updated@example.com",
               "nickname" => "updated-user",
               "status" => "active"
             }
           } = json_response(conn, 200)
  end

  test "DELETE /api/users/:user_id deletes a user", %{conn: conn} do
    assert {:ok, _user} =
             Accounts.create_user(%{
               "user_id" => 1004,
               "email" => "delete@example.com",
               "nickname" => "delete-user",
               "status" => "active"
             })

    conn = delete(conn, ~p"/api/users/1004")

    assert response(conn, 204)
    assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_by_user_id!(1004) end
  end

  test "POST /api/users returns validation errors", %{conn: conn} do
    conn =
      post(conn, ~p"/api/users", %{
        "user_id" => -1,
        "email" => "invalid",
        "nickname" => "no"
      })

    assert %{
             "errors" => %{
               "user_id" => [_],
               "email" => [_],
               "nickname" => [_]
             }
           } = json_response(conn, 422)
  end
end
