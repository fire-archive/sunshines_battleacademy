defmodule SunshinesBattleacademy.Web.LobbyChannel do
  use Phoenix.Channel
  require Logger

  # handles the special `"lobby"` subtopic
  def join("room:lobby", message, socket) do
    # init(%{socket: socket})
    send(self, :after_join)
    {:ok, socket}
  end

  def terminate(reason, socket) do
    ConCache.update_existing(:game_map, :player_list, fn(old_value) ->
      {:ok, Map.delete(old_value, socket.assigns[:user_id])}
    end)
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_info(:after_join, socket) do
    uid = UUID.uuid4
    push socket, "welcome", %{id: uid}
    ConCache.put(:game_map, socket.assigns[:user_id], %{id: uid})

    ConCache.update(:game_map, :player_list, fn(old_value) ->
      if old_value == nil do
        {:ok, Map.put(Map.new, socket.assigns[:user_id], uid)}
      else
        {:ok, Map.put(old_value, socket.assigns[:user_id], uid)}
      end
    end)

    {:noreply, socket}
  end

  def handle_in("gotit", %{"nickname" => nickname, "hue" => hue}, socket) do
    ConCache.update_existing(:game_map, socket.assigns[:user_id], fn(old_player) ->
      {:ok, %{id: old_player[:id], nickname: nickname, hue: hue, target: %{x: 0,y: 0}, position: %{x: 0,y: 0}}}
    end)
    {:noreply, socket}
  end

  def handle_in("movement", payload, socket) do
    ConCache.update_existing(:game_map, socket.assigns[:user_id], fn(old_value) ->
      tx = payload["target"]["x"] / 10
      ty = payload["target"]["y"] / 10
      length = :math.sqrt((tx*tx) + (ty*ty))
      target = if length > 15 do
        %{x: (tx / length) * 15, y: (ty / length) * 15}
      else
        %{x: tx, y: ty}
      end
      
      new_position = %{x: old_value.position[:x] + target[:x], y: old_value.position[:y] + target[:y]}

      {:ok, %{old_value | target: target, position: new_position}}
    end)

    players = ConCache.get(:game_map, :player_list)
    map = for {user_id, id} <- players do
      ConCache.get(:game_map, user_id)
      # Use target to calculate a new position for this player
    end
    push socket, "state_update", %{map: map}
    {:noreply, socket}
  end

  def init(state) do
    #schedule_work()
    {:ok, state}
  end

  # def handle_info(:work, state) do
  #   schedule_work() # Reschedule once more
  #   {:noreply, state.socket}
  # end

  # defp schedule_work() do
  #   Process.send_after(self(), :work, div(1000, 10))
  # end
end
