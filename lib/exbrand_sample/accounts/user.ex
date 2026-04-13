defmodule ExbrandSample.Accounts.User do
  @moduledoc """
  Phoenix / Ecto 境界で brand を保持する user schema。
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias ExbrandSample.Accounts.Types

  @type status() :: :active | :invited

  @type t() :: %__MODULE__{
          id: integer() | nil,
          user_id: Types.UserID.t() | nil,
          email: Types.Email.t() | nil,
          nickname: Types.Nickname.t() | nil,
          status: status() | nil
        }

  schema "users" do
    field :user_id, Types.UserID.ecto_type()
    field :email, Types.Email.ecto_type()
    field :nickname, Types.Nickname.ecto_type()
    field :status, Ecto.Enum, values: [:active, :invited], default: :invited
    timestamps(type: :utc_datetime)
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    normalized_attrs = normalize_user_id(attrs)

    user
    |> cast(normalized_attrs, [:user_id, :email, :nickname, :status])
    |> validate_required([:user_id, :email, :nickname, :status])
    |> unique_constraint(:user_id)
    |> unique_constraint(:email)
  end

  # HTML form の number input は文字列で届くため、integer cast を先に通す。
  defp normalize_user_id(%{} = attrs) do
    changeset =
      {%{}, %{user_id: :integer}}
      |> cast(attrs, [:user_id])

    case fetch_change(changeset, :user_id) do
      {:ok, user_id} -> Map.put(attrs, "user_id", user_id)
      :error -> attrs
    end
  end
end
