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
    |> validate_required([:name], message: "Nama supplier wajib diisi.")
    |> validate_length(:name,
      min: 2,
      max: 50,
      message: "Nama supplier minimal 2 karakter dan maksimal 50 karakter."
    )
    |> validate_length(:address,
      min: 5,
      max: 150,
      message: "Alamat supplier minimal 5 karakter dan maksimal 150 karakter."
    )
    |> unique_constraint([:name], message: "Nama supplier sudah ada yang punya")
  end
end
