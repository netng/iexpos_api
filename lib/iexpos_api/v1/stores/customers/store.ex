defmodule IexposApi.V1.Stores.Customers.Store do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix "public"
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "stores" do
    field :name, :string
    field :codename, :string
    # field :email, :string
    # field :phone_number, :string
    field :address, :string

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :codename, :address])
    |> validate_required([:name, :codename, :address])
    |> validate_format(:codename, ~r/^[a-zA-Z0-9]+$/, message: "Only letters are allowed, no special characters and spaces")
    # |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "Must have the @ sign and no spaces")
    |> validate_length(:name, max: 100)
    |> validate_length(:codename, max: 50)
    # |> validate_length(:email, max: 160)
    # |> validate_length(:address, max: 500)
    # |> validate_length(:phone_number, max: 25)
    |> unique_constraint([:codename])

  end

end
