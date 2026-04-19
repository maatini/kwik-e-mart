defmodule KwikEMart.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :title, :string, null: false
      add :description, :text
      add :ingredients, {:array, :string}, default: []
      add :instructions, :text
      add :prep_time, :integer
      add :image_url, :string
      add :tags, {:array, :string}, default: []
      add :seasonal, :boolean, default: false
      add :category_id, references(:categories, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create index(:recipes, [:category_id])
    create index(:recipes, [:seasonal])
  end
end
