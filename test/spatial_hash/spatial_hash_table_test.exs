defmodule SunshinesBattleacademy.SpatialHashTable.HashTableTest do
  use SunshinesBattleacademy.SpatialCase

  test "Hash", %{} do
    assert 19349669 == SunshinesBattleacademy.SpatialHash.hash(0, 1, 0)
  end

  test "Insert into hash table", %{} do
    assert :ok == SunshinesBattleacademy.SpatialHashTable.insert(%{x: 0,y: 1,z: 0}, [])
    assert :ok == SunshinesBattleacademy.SpatialHashTable.insert(%{x: 0,y: 1,z: 0}, [])
    assert :ok == SunshinesBattleacademy.SpatialHashTable.insert(%{x: 0,y: 1,z: 0}, [])
  end

  test "Find hash entry" do
    pos = %{x: 0,y: 1,z: 0}
    SunshinesBattleacademy.SpatialHashTable.insert(pos, %{position: pos, pointer: 0})
    assert %{pointer: 0, position: %{x: 0, y: 1, z: 0}} = SunshinesBattleacademy.SpatialHashTable.find(%{x: 0, y: 1, z: 0})
  end

  test "Test hash collision" do
  end
end
