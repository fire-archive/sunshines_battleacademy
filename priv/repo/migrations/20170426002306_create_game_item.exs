defmodule SunshinesBattleacademy.Repo.Migrations.CreateGameItem do
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    create table(:game_item, primary_key: false) do
      add :id, :bytea, primary_key: true
      add :nickname, :string
      add :hue, :int
      add :target_id, references(:target, type: :bytea)
      add :position_id, references(:position, type: :bytea)

      timestamps()
    end
  end
end
