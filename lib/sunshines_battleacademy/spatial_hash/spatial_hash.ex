defmodule SunshinesBattleacademy.SpatialHash do
  @max_safe_integer 9007199254740991
  use Bitwise

  def findBlock(pos, opts \\ []) do
    for	n <- pos do
        try do
          out = Riak.find({"strongly_consistent", "hash_table"}, to_string(hash(n.x, n.y, n.z)))
          {:ok, out}
        catch
          :exit, _ -> {:error, "There was an error finding the key."}
        end
    end
  end

  def findBlockPos(pos, opts \\ []) when is_list(pos) do
    for n <- pos, do: %{location: {n.x, n.y, n.z}, data: nil}
  end

  def putBlockPos(pos_data, opts \\ []) when is_list(pos_data) do
    for	n <- pos_data do
        %{pos: pos, data: data} = n
        fetch = []
        o = Riak.Object.create(type: "strongly_consistent", bucket: "hash_table", key: to_string(hash(n.x, n.y, n.z)), data: fetch ++ data)
        Riak.put(o)
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
