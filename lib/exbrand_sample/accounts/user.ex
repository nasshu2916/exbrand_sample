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
    user
    |> cast(attrs, [:user_id, :email, :nickname, :status])
    |> validate_required([:user_id, :email, :nickname, :status])
  end
end
