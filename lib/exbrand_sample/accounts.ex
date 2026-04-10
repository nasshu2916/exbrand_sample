defmodule ExbrandSample.Accounts do
  @moduledoc """
  User の永続化を担当する Accounts context。
  """

  alias ExbrandSample.Accounts.User
  alias ExbrandSample.Repo

  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec list_users() :: [User.t()]
  def list_users do
    Repo.all(User)
  end
end
