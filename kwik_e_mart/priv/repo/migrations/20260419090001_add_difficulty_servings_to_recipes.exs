defmodule KwikEMart.Repo.Migrations.AddDifficultyServingsToRecipes do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :difficulty, :string
      add :servings, :integer
    end
  end
end
