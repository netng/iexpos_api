  ## Note
  ## This file is only for tenant migration by schema_path
  ##
  defmodule IexposApi.Repo.Migrations.CreateUsersTable do
    use Ecto.Migration

    def change do
      create table(:users, primary_key: false) do
        add :id, :binary_id, primary_key: true
        add :fullname, :string
        add :gender, :string
        add :phone_number, :string, null: false
        add :address, :text
        add :account_id, references(:accounts, on_delete: :delete_all, type: :binary_id)

        timestamps()
      end

      create index(:users, [:fullname, :gender, :phone_number])
      create unique_index(:users, [:account_id])
    end
  end
