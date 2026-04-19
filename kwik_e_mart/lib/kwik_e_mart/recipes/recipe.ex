defmodule KwikEMart.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias KwikEMart.Offers.Category

  schema "recipes" do
    field :title, :string
    field :description, :string
    field :ingredients, {:array, :string}, default: []
    field :instructions, :string
    field :prep_time, :integer
    field :difficulty, :string
    field :servings, :integer
    field :image_url, :string
    field :tags, {:array, :string}, default: []
    field :seasonal, :boolean, default: false

    belongs_to :category, Category

    timestamps(type: :utc_datetime)
  end

  @required [:title]
  @optional [:description, :ingredients, :instructions, :prep_time, :difficulty, :servings, :image_url, :tags, :seasonal, :category_id]

  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_number(:prep_time, greater_than: 0)
    |> assoc_constraint(:category)
  end
end
