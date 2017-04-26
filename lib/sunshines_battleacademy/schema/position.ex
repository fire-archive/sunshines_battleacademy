defmodule SunshinesBattleacademy.Position do
  use Ecto.Schema

  @primary_key false
  @foreign_key_type :binary
  schema "position" do
    field :id, :binary, primary_key: true
    field :x, :integer
    field :y, :integer

    belongs_to :game_items, SunshinesBattleacademy.GameItem

    timestamps()
  end
end
