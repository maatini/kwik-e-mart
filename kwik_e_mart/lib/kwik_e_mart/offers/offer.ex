defmodule KwikEMart.Offers.Offer do
  use Ecto.Schema
  import Ecto.Changeset

  alias KwikEMart.Markets.Market
  alias KwikEMart.Offers.Category

  schema "offers" do
    field :title, :string
    field :description, :string
    field :price, :decimal
    field :original_price, :decimal
    field :discount_percent, :integer
    field :image_url, :string
    field :valid_from, :date
    field :valid_to, :date

    belongs_to :market, Market
    belongs_to :category, Category

    timestamps(type: :utc_datetime)
  end

  @required [:title, :price, :valid_from, :valid_to]
  @optional [
    :description,
    :original_price,
    :discount_percent,
    :image_url,
    :category_id,
    :market_id
  ]

  def changeset(offer, attrs) do
    offer
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:discount_percent, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_dates()
    |> assoc_constraint(:market)
    |> assoc_constraint(:category)
  end

  defp validate_dates(changeset) do
    valid_from = get_field(changeset, :valid_from)
    valid_to = get_field(changeset, :valid_to)

    if valid_from && valid_to && Date.compare(valid_to, valid_from) == :lt do
      add_error(changeset, :valid_to, "muss nach valid_from liegen")
    else
      changeset
    end
  end
end
