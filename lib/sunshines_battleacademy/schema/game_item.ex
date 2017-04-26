defmodule SunshinesBattleacademy.GameItem do
  use Ecto.Schema

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
end

