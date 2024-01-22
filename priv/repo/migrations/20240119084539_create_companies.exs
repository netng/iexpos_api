defmodule IexposApi.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :code, :string
      add :email, :string
      add :phone_number, :string
      add :address, :text
      add :pic_name, :string

      timestamps()
    end

    create unique_index(:companies, [:name, :code])
  end
end
