defmodule SunshinesBattleacademy.Web.LobbyChannel do
  use Phoenix.Channel
  alias SunshinesBattleacademy.Cache
  require Logger

  # handles the special `"lobby"` subtopic
  def join("room:lobby", _message, socket) do
    :timer.send_interval(50, :work)
    send(self(), :after_join)
    {:ok, socket}
  end

  def terminate(reason, socket) do
    Cache.update(:player_list, %{}, fn old_value ->
      Map.delete(old_value, socket.assigns[:user_id])
    end)

    Logger.debug("> leave #{inspect(reason)}")
    :ok
  end

  def handle_info(:work, socket) do
    players = Cache.get(:player_list)

    Cache.update(socket.assigns[:user_id], %{position: %{x: 0, y: 0}}, fn elem ->
      if elem[:target] == nil do
        elem
      else
        target = normalize_target(elem.target)
        new_position = %{x: elem.position[:x] + target[:x], y: elem.position[:y] + target[:y]}
        %{elem | position: new_position}
      end
    end)

    map =
      for {user_id, _id} <- players do
        Cache.get(user_id)
        # Use target to calculate a new position for this player
      end

    push(socket, "state_update", %{map: map})
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    uid = UUID.uuid4()
    push(socket, "welcome", %{id: uid})
    Cache.set(socket.assigns[:user_id], %{id: uid})

    Cache.update(:player_list, Map.put(Map.new(), socket.assigns[:user_id], uid), fn old_value ->
      Map.put(old_value, socket.assigns[:user_id], uid)
    end)

    {:noreply, socket}
  end

  def handle_in("gotit", %{"nickname" => nickname, "hue" => hue}, socket) do
    Cache.update(
      socket.assigns[:user_id],
      %{
        id: socket.assigns[:user_id],
        nickname: nickname,
        hue: hue,
        target: %{x: 0, y: 0},
        position: %{x: 0, y: 0}
      },
      fn old_player ->
        %{
          id: old_player[:id],
          nickname: nickname,
          hue: hue,
          target: %{x: 0, y: 0},
          position: %{x: 0, y: 0}
        }
      end
    )

    Cache.update(
      socket.assigns[:user_id],
      %{
        id: socket.assigns[:user_id],
        nickname: nickname,
        hue: hue,
        target: %{x: 0, y: 0},
        position: %{x: 0, y: 0}
      },
      fn old_player ->
        %{
          id: old_player[:id],
          nickname: nickname,
          hue: hue,
          target: %{x: 0, y: 0},
          position: %{x: 0, y: 0}
        }
      end
    )

    {:noreply, socket}
  end

  def handle_in("movement", payload, socket) do
    Cache.update(socket.assigns[:user_id], nil, fn old_value ->
      if old_value[:target] == nil do
      else
        %{old_value | target: %{x: payload["target"]["x"], y: payload["target"]["y"]}}
      end
    end)

    {:noreply, socket}
  end

  def normalize_target(target) do
    tx = target[:x] / 10
    ty = target[:y] / 10
    length = :math.sqrt(tx * tx + ty * ty)

    if length > 15 do
      %{x: tx / length * 15, y: ty / length * 15}
    else
      %{x: tx, y: ty}
    end
  end
end
