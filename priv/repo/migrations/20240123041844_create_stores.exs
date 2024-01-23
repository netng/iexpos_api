defmodule IexposApi.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def change do
    create table(:stores, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :codename, :string
      add :email, :string
      add :phone_number, :string
      add :address, :text

      timestamps()
    end

    create unique_index(:stores, [:codename])
    create index(:stores, [:name, :email, :phone_number])
  end
end
