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
    Logger.debug"Receiving movement heartbeat"
    push socket, "state_update", %{"Hello": "World"}
    {:noreply, socket}
  end

  def handle_in("gotit", payload, socket) do
    ConCache.put(:game_world, socket.assigns[:user_id], %{nickname: payload["nickname"], hue: payload["hue"], target: {0,0}, position: {0,0}})
    {:noreply, socket}
  end
end