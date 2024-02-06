defmodule IexposApi.V1.Stores.Customers.Account do
  alias IexposApi.V1.Stores.Customers.User
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :email, :string
    field :username, :string
    field :hash_password, :string

    has_one :user, User

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :username, :hash_password])
    |> validate_required([:email, :hash_password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "Must have the @ sign and no spaces")
    |> validate_format(:username, ~r/^[a-zA-Z0-9]+$/,
      message: "Only letters are allowed, no special characters and spaces"
    )
    |> validate_length(:username, max: 100)
    |> validate_length(:email, max: 160)
    |> unique_constraint([:email, :username])
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{hash_password: hash_password}} = changeset
       ) do
    change(changeset, hash_password: Bcrypt.hash_pwd_salt(hash_password))
  end

  defp put_password_hash(changeset), do: changeset
end
