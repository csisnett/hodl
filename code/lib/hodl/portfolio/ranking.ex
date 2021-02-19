defmodule Hodl.Portfolio.Ranking do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hodl.Portfolio.{NameSlug}

  schema "rankings" do
    field :name, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :slug, NameSlug.Type
    timestamps()
  end

  @doc false
  def changeset(ranking, attrs) do
    ranking
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> NameSlug.maybe_generate_slug
    |> unique_constraint(:slug)
  end
end
