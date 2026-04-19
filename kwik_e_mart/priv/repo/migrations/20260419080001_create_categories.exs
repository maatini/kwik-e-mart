defmodule KwikEMart.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :type, :string, null: false
      add :icon, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:categories, [:slug, :type])
  end
end
