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
  
  def terminate(reason, socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end
  
  def handle_in("gotit", payload, socket) do
    ConCache.put(:game_map, socket.assigns[:user_id], %{nickname: payload["nickname"], hue: payload["hue"], target: %{x: 0,y: 0}, position: %{x: 0,y: 0}})
    {:noreply, socket}
  end

  def handle_in("movement", payload, socket) do
    ConCache.update_existing(:game_map, socket.assigns[:user_id], fn(old_value) ->
      # Normalize direction if needed
      tx = payload["target"]["x"] / 10
      ty = payload["target"]["y"] / 10
      length = :math.sqrt((tx*tx) + (ty*ty))
      target = if length > 15 do
        %{x: (tx / length) * 15, y: (ty / length) * 15}
      else
        %{x: tx, y: ty}
      end
      
      position_x = old_value[:position][:x] + target[:x]
      position_y = old_value[:position][:y] + target[:y]
      new_position = %{x: position_x, y: position_y}

      new_value = %{old_value | position: new_position, target: target}
      {:ok, new_value}
    end)
    push socket, "state_update", %{data: ConCache.get(:game_map, socket.assigns[:user_id])}
    {:noreply, socket}
  end
end