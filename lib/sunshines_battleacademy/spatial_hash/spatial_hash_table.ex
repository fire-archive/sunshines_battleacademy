defmodule SunshinesBattleacademy.SpatialHashTable do
  # Insert position and get %{pos, block_pointer}
  def insert(pos) do
    key = SunshinesBattleacademy.SpatialHash.hash(pos.x, pos.y, pos.z)
    block_pointer = 1

    ConCache.insert_new(:hash_table, key, %ConCache.Item{
      value: %{pos: pos, block_pointer: block_pointer},
      ttl: 0
    })
  end

  def find(pos) do
    key = SunshinesBattleacademy.SpatialHash.hash(pos.x, pos.y, pos.z)

    case ConCache.get(:hash_table, key) do
      nil -> {:error, "Can't find position"}
      other -> other.value
    end
  end

  def delete(pos) do
    key = SunshinesBattleacademy.SpatialHash.hash(pos.x, pos.y, pos.z)
    # linear walk
    for n <- ConCache.get(:hash_table, key).value do
      if n == "something" do
      else
        n
      end
    end
  end
end
