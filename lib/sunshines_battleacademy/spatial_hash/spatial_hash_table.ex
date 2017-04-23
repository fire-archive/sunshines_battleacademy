defmodule SunshinesBattleacademy.SpatialHashTable do
  def insert(pos, data) do
    key = SunshinesBattleacademy.SpatialHash.hash(pos.x, pos.y, pos.z)
    case ConCache.insert_new(:hash_table, key, %ConCache.Item{value: data, ttl: 0}) do
            {:error, :already_exists} ->
              ConCache.update_existing(:hash_table, key, fn(old_value) ->
                # TODO FIX
                {:ok, %ConCache.Item{value: data, ttl: :no_update}}
              end)
            other -> other
    end
  end

  def find(pos) do
    key = SunshinesBattleacademy.SpatialHash.hash(pos.x, pos.y, pos.z)
    ConCache.get(:hash_table, key).value
  end

  def delete(pos) do
  end
end
