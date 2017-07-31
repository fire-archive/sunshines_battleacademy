defmodule SunshinesBattleacademy.SpatialHashZord do
@max_position 9007199254740991
@origin div(9007199254740991, 2)
@spatial_config :erlzord.config(3, 0, @max_position)
    def encode({x, y, z} = pos) when is_integer(x) and is_integer(y) and is_integer(z) do
        :erlzord.encode(shift_origin(pos), @spatial_config)
    end

    def decode(int) when is_integer(int) do
        unshift_origin(:erlzord.decode(int, @spatial_config))
    end

    def shift_origin({x, y, z}) when is_integer(x) and is_integer(y) and is_integer(z) do
       {x + @origin, y + @origin, z + @origin} 
    end

    def unshift_origin({x, y, z}) when is_integer(x) and is_integer(y) and is_integer(z) do
       {x - @origin, y - @origin, z - @origin} 
    end
end 