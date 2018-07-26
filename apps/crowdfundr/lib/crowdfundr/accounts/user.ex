defmodule Crowdfundr.Accounts.User do
  @moduledoc """
  A user struct.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Comeonin.Argon2
  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> put_password_hash()
    |> unique_constraint(:email)
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Argon2.hashpwsalt(password))
  end
  defp put_password_hash(changeset), do: changeset
end
