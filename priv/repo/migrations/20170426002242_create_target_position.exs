defmodule SunshinesBattleacademy.Repo.Migrations.CreateTargetPosition do
  use Ecto.Migration

  def change do
    create table(:target, primary_key: false) do
      add :id, :bytea, primary_key: true
      add :x, :int
      add :y, :int

      timestamps()
    end

    create table(:position, primary_key: false) do
      add :id, :bytea, primary_key: true
      add :x, :int
      add :y, :int

      timestamps()
    end
  end
end
