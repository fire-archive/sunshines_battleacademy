defmodule SunshinesBattleacademy.Web.LobbyChannel do
  use Phoenix.Channel
  require Logger

  # handles the special `"lobby"` subtopic
  def join("room:lobby", message, socket) do
    # init(%{socket: socket})
    ConCache.put(:game_map, :player_list, Map.new)
    {:ok, socket}
  end

  def terminate(reason, socket) do
    ConCache.update(:game_map, :player_list, fn(old_value) ->
      unless old_value == nil do
        {:ok, Map.delete(old_value, user_id_to_id(socket.assigns[:user_id]))}
      else
        {:ok, nil}
      end
    end)
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("gotit", payload, socket) do
    ConCache.update(:game_map, :player_list, fn(old_value) ->
      unless old_value == nil do
        {:ok, Map.put(old_value, socket.assigns[:user_id], UUID.uuid4())}
      else
        {:ok, Map.put(Map.new, socket.assigns[:user_id], UUID.uuid4())}
      end
    end)
    ConCache.put(:game_map, user_id_to_id(socket.assigns[:user_id]), %{nickname: payload["nickname"], hue: payload["hue"], target: %{x: 0,y: 0}, position: %{x: 0,y: 0}})
    {:noreply, socket}
  end

  def handle_in("movement", payload, socket) do
    ConCache.update_existing(:game_map, user_id_to_id(socket.assigns[:user_id]), fn(old_value) ->
      position_x = old_value[:position][:x] + payload["target"]["x"]
      position_y = old_value[:position][:y] + payload["target"]["y"]
      new_position = %{x: position_x, y: position_y}

      new_value = %{old_value | position: new_position, target: payload["target"]}
      {:ok, new_value}
    end)
    players = ConCache.get(:game_map, :player_list)
    Logger.debug inspect players
    map = for n <- Map.to_list(players) do
      Logger.debug inspect n
      {user_id, id} = n
      elem = ConCache.get(:game_map, id)
      Logger.debug inspect elem
      tx = Map.get(elem.target, "x") / 10
      ty = Map.get(elem.target, "y") / 10
      length = :math.sqrt((tx*tx) + (ty*ty))
      target = if length > 15 do
        %{x: (tx / length) * 15, y: (ty / length) * 15}
      else
        %{x: tx, y: ty}
      end
      # Use target to calculate a new position for this player
    end
    push socket, "state_update", %{map: map}
    {:noreply, socket}
  end

  def user_id_to_id(id) do
    players = ConCache.get(:game_map, :player_list)
    Map.get(players, id)
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
