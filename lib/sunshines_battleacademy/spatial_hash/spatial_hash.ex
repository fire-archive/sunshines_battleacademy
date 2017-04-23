defmodule SunshinesBattleacademy.SpatialHash do
  @max_safe_integer 9007199254740991
  @hash_table "hash_table"
  use Bitwise

  # SunshinesBattleacademy.SpatialHash.findBlock([%{x: 0, y: 1, z: 0}]) 
  def findBlockFromPosition(pos, opts \\ []) do
    # TODO Parallelize
    for	n <- pos do
        loc = ConCache.get(:hash_table, hash(n.x, n.y, n.z))
        for n <- loc.value do
          if n.pos == pos do
            findBlock(n.pointer)
          end
        end
    end
  end

  # Given hash id fetch block
  def findBlock(block_id_list, opts \\ []) when is_list(block_id_list) do
    # TODO Parallelize
    for n <- block_id_list do
      ConCache.get(:voxel, n)
    end
  end

  def findBlockPos(pos, opts \\ []) when is_list(pos) do
    for n <- pos, do: %{location: {n.x, n.y, n.z}, data: nil}
  end

  # SunshinesBattleacademy.SpatialHash.putBlockPos([%{pos: %{x: 0, y: 1, z: 0}, data: []}])
  def putBlockPos(pos_data, opts \\ []) when is_list(pos_data) do
    # Todo Parallize
    for	n <- pos_data do
        %{pos: pos, data: data} = n
        SunshinesBattleacademy.SpatialHashTable.hashTableInsert(pos, data)
    end
  end

  def hash(x, y, z) do
    mod((x * 73856093) ^^^ (y * 19349669) ^^^ (z * 83492791),
      @max_safe_integer)
  end

  @doc """
  Modulo operation.

  Returns the remainder after division of `number` by `modulus`.
  The sign of the result will always be the same sign as the `modulus`.
  """
  # https://github.com/eksperimental/experimental_elixir/blob/master/lib/kernel_modulo.ex
  @spec mod(integer, integer) :: non_neg_integer
  def mod(number, modulus) when is_integer(number) and
  is_integer(modulus) do
    case rem(number, modulus) do
      remainder when remainder > 0 and modulus < 0
      or remainder < 0 and modulus > 0 ->
        remainder + modulus
      remainder ->
        remainder
    end
  end
end
