  ## Note
  ## This file is only for tenant migration by schema_path
  ##
  defmodule IexposApi.Repo.Migrations.AddSupplierTable do
    use Ecto.Migration

    def change do
      create table(:suppliers, primary_key: false) do
        add :id, :binary_id, primary_key: true
        add :name, :string, null: false
        add :phone_number, :string, null: true
        add :email, :string, null: true
        add :address, :text, null: true

        timestamps()
      end

      create index(:suppliers, [:name, :email, :phone_number])
      create unique_index(:suppliers, [:name])
    end
  end
