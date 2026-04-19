defmodule KwikEMart.Repo.Migrations.CreateMarkets do
  use Ecto.Migration

  def change do
    create table(:markets) do
      add :name, :string, null: false
      add :city, :string, null: false
      add :zip, :string, null: false
      add :street, :string, null: false
      add :latitude, :float
      add :longitude, :float
      add :region, :string

      timestamps(type: :utc_datetime)
    end

    create index(:markets, [:city])
    create index(:markets, [:zip])
    create index(:markets, [:region])
  end
end
