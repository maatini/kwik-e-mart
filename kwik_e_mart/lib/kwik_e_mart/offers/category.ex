defmodule KwikEMart.Offers.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias KwikEMart.Offers.Offer

  @type t :: %__MODULE__{}

  schema "categories" do
    field :name, :string
    field :slug, :string
    field :type, :string
    field :icon, :string

    has_many :offers, Offer

    timestamps(type: :utc_datetime)
  end

  @required [:name, :slug, :type]
  @optional [:icon]

  def changeset(category, attrs) do
    category
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_inclusion(:type, ["offer", "recipe"])
    |> unique_constraint([:slug, :type])
  end
end
