defmodule KwikEMart.Repo.Migrations.MakeOfferMarketIdOptional do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE offers ALTER COLUMN market_id DROP NOT NULL")
  end

  def down do
    execute("ALTER TABLE offers ALTER COLUMN market_id SET NOT NULL")
  end
end
