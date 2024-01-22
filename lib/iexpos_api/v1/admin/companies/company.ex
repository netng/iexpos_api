defmodule IexposApi.V1.Admin.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix "public"
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "companies" do
    field :name, :string
    field :code, :string
    field :email, :string
    field :phone_number, :string
    field :address, :string
    field :pic_name, :string

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :code, :email, :phone_number, :address, :pic_name])
    |> validate_required([:name, :code, :email, :phone_number, :address, :pic_name])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:name, max: 100)
    |> validate_length(:email, max: 160)
    |> validate_length(:address, max: 500)
    |> validate_length(:phone_number, max: 25)
    |> validate_length(:pic_name, max: 100)
    |> unique_constraint([:name, :code])

  end

end
