defmodule KwikEMart.Markets.Market do
  use Ecto.Schema
  import Ecto.Changeset

  alias KwikEMart.Offers.Offer

  schema "markets" do
    field :name, :string
    field :city, :string
    field :zip, :string
    field :street, :string
    field :latitude, :float
    field :longitude, :float
    field :region, :string

    has_many :offers, Offer

    timestamps(type: :utc_datetime)
  end

  @required [:name, :city, :zip, :street]
  @optional [:latitude, :longitude, :region]

  def changeset(market, attrs) do
    market
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:zip, min: 4, max: 10)
  end
end
