defmodule SunshinesBattleacademy.SpatialLookup do
  # Insert position and get %{pos, block_pointer}
  def insert({x, y, z} = pos) when is_integer(x) and is_integer(y) and is_integer(z) do
    key = SunshinesBattleacademy.SpatialHashZord.encode(pos)
    block_pointer = 1

    ConCache.insert_new(:hash_table, key, %ConCache.Item{
      value: %{pos: pos, block_pointer: block_pointer},
      ttl: 0
    })
  end

  def find({x, y, z} = pos) when is_integer(x) and is_integer(y) and is_integer(z) do
    key = SunshinesBattleacademy.SpatialHashZord.encode(pos)

    case ConCache.get(:hash_table, key) do
      nil -> {:error, "Can't find position"}
      other -> other.value
    end
  end

  def delete({x, y, z} = pos) when is_integer(x) and is_integer(y) and is_integer(z) do
    key = SunshinesBattleacademy.SpatialHashZord.encode(pos)
    ConCache.delete(:hash_table, key)
  end
end
