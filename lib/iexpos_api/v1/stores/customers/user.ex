defmodule IexposApi.V1.Stores.Customers.User do
  alias IexposApi.V1.Stores.Customers.Account
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :fullname, :string
    field :gender, :string
    field :phone_number, :string
    field :address, :string

    belongs_to :account, Account

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id, :fullname, :gender, :phone_number, :address])
    |> validate_required([:account_id, :phone_number])
    |> validate_length(:fullname, max: 100)
    |> validate_length(:phone_number, max: 25)
    |> validate_length(:address, max: 500)
    |> unique_constraint([:account_id])
  end

end
