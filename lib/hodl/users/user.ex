defmodule Hodl.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset
  use Pow.Extension.Ecto.Schema, extensions: [PowResetPassword]

  schema "users" do
    field :username, :string
    pow_user_fields()

    timestamps()
  end

  def generate_random_combination do
    adjectives = ["good", "super", "president",
    "minister", "fearless", "thoughtful", "brave",
    "amazing", "awesome", "optimistic", "faithful", "proficient", "marvelous",
    "excellent", "productive", "responsible", "focused", "efficient",
    "bright", "determined", "energetic", "generous", "imaginative",
    "helpful", "kind", "diligent", "patient", "dynamic", "loyal",
    "diplomatic", "considerate", "elegant"]

    nouns = ["apple", "taco", "water", "sushi",
     "pizza", "light", "snow",  "bread",
     "tomato", "book", "liquid", "platypus", "stardust",
      "pencil", "pizzeria", "noodle", "fan", "chair",
      "table", "pan", "spaguetti", "enchilada",
      "empanada", "milk", "cheese", "tacos",
      "ravioli", "panda", "lake", "cup", "laptop", "igloo", "hyperlink",
      "gym", "elixir", "gold",
      "bit", "agua", "ruby", "gem", "diamond", "cookie", "pow",
      "swift", "grande", "hodl", "hodler", "mello", "marshmello",
      "mars", "venus", "neptune", "pluto", "saturn", "andromeda",
      "milkyway", "owl", "acqua", "moon", "blueclues", "cafe", "coffee",
      "chocolate", "almond", "tea", "sun", "phoenix", "tiger", "giraffe",
      "zebra"]

    noun_or_adjective = :rand.uniform(2)
    random_number =  :rand.uniform(999) |> Integer.to_string
    case noun_or_adjective do
      1 -> 
        adjective = Enum.random(adjectives)
        adjective <> random_number
      2 ->
        noun = Enum.random(nouns)
        noun <> random_number
    end
  end

  def generate_random_username(changeset) do
    case get_field(changeset, :username) do
      nil -> changeset |> put_change(:username, generate_random_combination())
      _username -> changeset
    end
  end

  def lowercase_username(changeset) do
    case get_field(changeset, :username) do
      nil -> changeset
      username ->
        if username == String.downcase(username) do
          changeset
        else
          changeset |> put_change(:username, String.downcase(username))
      end
      
    end
  end

  def replace_white_space(changeset) do
    case get_field(changeset, :username) do
      nil -> changeset
      username ->
        changeset |> put_change(:username, String.replace(username, ~r/ +/, ""))
    end
  end



  def changeset(user, attrs) do
    attrs = put_confirm_password(attrs)

    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:email])
    |> generate_random_username
    |> lowercase_username
    |> replace_white_space
    |> validate_length(:username, max: 15)
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  defp put_confirm_password(attrs) do
    case has_confirm_password?(attrs) do
      true  -> attrs
      false -> Map.put(attrs, "password_confirmation", attrs["password"])
    end
  end

  defp has_confirm_password?(%{"password_confirmation" => confirm_password}) when is_binary(confirm_password) and confirm_password != "", do: true
  defp has_confirm_password?(_attrs), do: false
end
