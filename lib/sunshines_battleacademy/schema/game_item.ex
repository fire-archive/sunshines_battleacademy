defmodule SunshinesBattleacademy.GameItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary
  schema "game_item" do
    field :id, :binary, primary_key: true, default: Ecto.UUID.bingenerate()
    field :hue, :integer
    field :nickname, :string
    
    belongs_to :position, SunshinesBattleacademy.Position
    belongs_to :target, SunshinesBattleacademy.Target

    timestamps()
  end

  @required_fields ~w(hue nickname)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.
  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end

