defmodule ExbrandSample.AccountsTest do
  use ExbrandSample.DataCase, async: true

  alias ExbrandSample.Accounts
  alias ExbrandSample.Accounts.Types
  alias ExbrandSample.Accounts.User

  test "create_user/1 が Ecto changeset 経由で brand field を構築する" do
    assert {:ok, user} =
             Accounts.create_user(%{
               "user_id" => 42,
               "email" => "user@example.com",
               "nickname" => "test_user"
             })

    assert %User{} = user
    assert Types.UserID.unwrap(user.user_id) == 42
    assert Types.Email.unwrap(user.email) == "user@example.com"
    assert Types.Nickname.unwrap(user.nickname) == "test_user"
    assert user.status == :invited
  end

  test "不正な値は changeset error として返る" do
    assert {:error, changeset} =
             Accounts.create_user(%{
               "user_id" => -1,
               "email" => "invalid",
               "nickname" => "no"
             })

    refute changeset.valid?
    assert %{user_id: [_], email: [_], nickname: [_]} = errors_on(changeset)
  end
end
