defmodule Accountable.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    # attrs = put_password_hash(attrs)

    user
    |> cast(attrs, [:email, :password_hash])
    |> validate_required([:email, :password_hash])
  end

  def put_password_hash(attrs) do
    # Accountable.put_password_hash(attrs)
  end
end
