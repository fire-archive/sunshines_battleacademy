defmodule SunshinesBattleacademy.Web.LobbyChannel do
  use Phoenix.Channel
  require Logger

  # handles the special `"lobby"` subtopic
  def join("room:lobby", message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end
  
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
  
  def handle_info(:after_join, socket) do
    broadcast! socket, "player_joined", %{body: "aoeu"}
    {:noreply, socket}
  end
  
  def terminate(reason, socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end
  
  def handle_in("movement_heartbeat", payload, socket) do
    raise Test
    Logger.debug"receiving incoming movement heartbeat"
    ConCache.update_existing(:game_world, socket.assigns[:user_id], fn(old_value) ->
      position_x = old_value.position["x"] + payload.target["x"]
      position_y = old_value.position["y"] + payload.target["y"]
      new_position = %{x: position_x, y: position_y}

      new_value = %{old_value | position: new_position, target: payload.target}
      {:ok, new_value}
    end)
    push socket, "state_update", %{data: ConCache.get(:game_world, socket.assigns[:user_id])}
    {:noreply, socket}
  end

  def handle_in("gotit", payload, socket) do
    ConCache.put(:game_world, socket.assigns[:user_id], %{hello: "world"})
    {:noreply, socket}
  end
end