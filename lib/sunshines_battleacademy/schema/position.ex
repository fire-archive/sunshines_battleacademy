defmodule SunshinesBattleacademy.Position do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary
  schema "position" do
    field(:id, :binary, primary_key: true, default: Ecto.UUID.bingenerate())
    field(:x, :integer)
    field(:y, :integer)

    belongs_to(:game_items, SunshinesBattleacademy.GameItem)

    timestamps()
  end

  @required_fields ~w(id x y)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.
  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:id)
  end
end
