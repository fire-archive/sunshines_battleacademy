defmodule SunshinesBattleacademy.GameItem do
  use Ecto.Schema

  @primary_key false
  schema "game_items" do
    field :id, :binary, primary_key: true
    field :hue, :integer
    field :nickname, :string
    
    belongs_to :position, SunshinesBattleacademy.Position
    belongs_to :target, SunshinesBattleacademy.Target

    timestamps()
  end
end

