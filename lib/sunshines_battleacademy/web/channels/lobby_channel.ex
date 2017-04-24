defmodule SunshinesBattleacademy.Web.LobbyChannel do
  use Phoenix.Channel
  require Logger

  # handles the special `"lobby"` subtopic
  def join("room:lobby", message, socket) do
    send(self(), :after_join)
    SunshinesBattleacademy.Worker.WorldStateUpdate.init(%{socket: socket})
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def terminate(reason, socket) do
    ConCache.update(:game_map, :player_list, fn(old_value) ->
      {:ok, Map.drop(old_value, socket.assigns[:user_id])}
      end)
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("gotit", payload, socket) do
    ConCache.put(:game_map, socket.assigns[:user_id], %{nickname: payload["nickname"], hue: payload["hue"], target: %{x: 0,y: 0}, position: %{x: 0,y: 0}})
    ConCache.update(:game_map, :player_list, fn(old_value) ->
      Logger.debug inspect old_value
      {:ok, Map.put(old_value, socket.assigns[:user_id], UUID.uuid4())}
    end)
    {:noreply, socket}
  end

  def handle_in("movement", payload, socket) do
    ConCache.update_existing(:game_map, socket.assigns[:user_id], fn(old_value) ->
      position_x = old_value[:position][:x] + payload["target"]["x"]
      position_y = old_value[:position][:y] + payload["target"]["y"]
      new_position = %{x: position_x, y: position_y}

      new_value = %{old_value | position: new_position, target: payload["target"]}
      {:ok, new_value}
    end)
    #push socket, "state_update", %{data: ConCache.get(:game_map, socket.assigns[:user_id])}
    {:noreply, socket}
  end
end
