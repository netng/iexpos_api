  defmodule IexposApi.Repo.Migrations.CreateAccountsTable do
    use Ecto.Migration

    def change do
      create table(:accounts, primary_key: false) do
        add :id, :binary_id, primary_key: true
        add :email, :string
        add :username, :string
        add :hash_password, :string

        timestamps()
      end

      create unique_index(:accounts, [:email, :username])
    end
  end
