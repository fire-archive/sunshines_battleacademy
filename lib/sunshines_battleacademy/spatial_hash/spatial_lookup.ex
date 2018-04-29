defmodule SunshinesBattleacademy.SpatialLookup do
  alias SunshinesBattleacademy.SpatialCache, as: Cache
  # Insert position and get %{pos, block_pointer}
  def insert({x, y, z} = pos) when is_integer(x) and is_integer(y) and is_integer(z) do
    key = SunshinesBattleacademy.SpatialHashZord.encode(pos)
    block_pointer = 1

    Cache.set(key, %{pos: pos, block_pointer: block_pointer})
  end

  def find({x, y, z} = pos) when is_integer(x) and is_integer(y) and is_integer(z) do
    key = SunshinesBattleacademy.SpatialHashZord.encode(pos)

    case Cache.get(key) do
      nil -> {:error, "Can't find position"}
      other -> other.value
    end
  end

  def delete({x, y, z} = pos) when is_integer(x) and is_integer(y) and is_integer(z) do
    key = SunshinesBattleacademy.SpatialHashZord.encode(pos)
    Cache.delete(key)
  end
end
