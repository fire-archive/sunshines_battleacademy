defmodule SunshinesBattleacademy.SpatialBlock do
  def findBlockFromPosition(pos, _opts \\ []) do
    # TODO Parallelize
    for	n <- pos do
        loc = ConCache.get(:hash_table, SunshinesBattleacademy.SpatialHashZord.encode({n.x, n.y, n.z}))
        for n <- loc.value do
          if n.pos == pos do
            findBlock(n.pointer)
          end
        end
    end
  end

  # Given key fetch block
  def findBlock(block_id_list, _opts \\ []) when is_list(block_id_list) do
    # TODO Parallelize
    for n <- block_id_list do
      ConCache.get(:voxel, n)
    end
  end

  def findBlockPos(pos, _opts \\ []) when is_list(pos) do
    for n <- pos, do: %{location: {n.x, n.y, n.z}, data: nil}
  end

  def putBlockPos(pos_data, _opts \\ []) when is_list(pos_data) do
    # Todo Parallize
    for	n <- pos_data do
        %{pos: pos, data: _data} = n
        SunshinesBattleacademy.SpatialLookup.insert(pos)
    end
  end
end
