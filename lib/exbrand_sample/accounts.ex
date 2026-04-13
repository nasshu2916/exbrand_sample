defmodule ExbrandSample.Accounts do
  @moduledoc """
  User の永続化を担当する Accounts context。
  """

  alias ExbrandSample.Accounts.Types
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

  @spec get_user_by_user_id(String.t() | integer()) :: {:ok, User.t()} | :error
  def get_user_by_user_id(user_id) do
    with {:ok, branded_user_id} <- cast_user_id(user_id),
         %User{} = user <- Repo.get_by(User, user_id: branded_user_id) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  @spec get_user_by_user_id!(String.t() | integer()) :: User.t()
  def get_user_by_user_id!(user_id) do
    case get_user_by_user_id(user_id) do
      {:ok, user} -> user
      :error -> raise Ecto.NoResultsError, queryable: User
    end
  end

  @spec update_user(User.t(), map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @spec update_user_by_user_id(String.t() | integer(), map()) ::
          {:ok, User.t()} | {:error, Ecto.Changeset.t()} | :error
  def update_user_by_user_id(user_id, attrs) do
    with {:ok, user} <- get_user_by_user_id(user_id) do
      update_user(user, attrs)
    end
  end

  @spec delete_user_by_user_id(String.t() | integer()) ::
          {:ok, User.t()} | {:error, Ecto.Changeset.t()} | :error
  def delete_user_by_user_id(user_id) do
    with {:ok, user} <- get_user_by_user_id(user_id) do
      delete_user(user)
    end
  end

  @spec change_user(User.t(), map()) :: Ecto.Changeset.t()
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  defp cast_user_id(user_id), do: Ecto.Type.cast(Types.UserID.ecto_type(), user_id)
end
