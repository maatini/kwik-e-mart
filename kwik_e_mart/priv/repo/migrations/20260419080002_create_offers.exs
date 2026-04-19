defmodule KwikEMart.Repo.Migrations.CreateOffers do
  use Ecto.Migration

  def change do
    create table(:offers) do
      add :title, :string, null: false
      add :description, :text
      add :price, :decimal, precision: 10, scale: 2, null: false
      add :original_price, :decimal, precision: 10, scale: 2
      add :discount_percent, :integer
      add :image_url, :string
      add :valid_from, :date, null: false
      add :valid_to, :date, null: false
      add :market_id, references(:markets, on_delete: :delete_all), null: false
      add :category_id, references(:categories, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create index(:offers, [:market_id])
    create index(:offers, [:category_id])
    create index(:offers, [:valid_from, :valid_to])
    create index(:offers, [:market_id, :valid_from, :valid_to])
  end
end
