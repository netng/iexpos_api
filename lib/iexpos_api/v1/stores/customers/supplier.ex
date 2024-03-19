defmodule IexposApi.V1.Stores.Customers.Supplier do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "suppliers" do
    field :name, :string
    field :phone_number, :string
    field :email, :string
    field :address, :string

    timestamps()
  end

  @doc false
  def changeset(supplier, attrs) do
    supplier
    |> cast(attrs, [:name, :phone_number, :email, :address])
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
    |> validate_length(:name, max: 50)
    |> unique_constraint([:name])
  end
end
