defmodule SunshinesBattleacademy.Web.LobbyChannel do
  use Phoenix.Channel
  require Logger

  # handles the special `"lobby"` subtopic
  def join("room:lobby", _message, socket) do
    :timer.send_interval(50, :work)
    send(self(), :after_join)
    {:ok, socket}
  end

  def terminate(reason, socket) do
    {:ok, id} = Ecto.UUID.dump(socket.assigns[:user_id])
    # player = SunshinesBattleacademy.Repo.get!(SunshinesBattleacademy.GameItem, id)  
    #  |> SunshinesBattleacademy.Repo.preload(:position)
    #  |> SunshinesBattleacademy.Repo.preload(:target)
    # SunshinesBattleacademy.Repo.delete(player)

    Logger.debug("> leave #{inspect(reason)}")
    :ok
  end

  def handle_info(:work, socket) do
    players = SunshinesBattleacademy.Repo.all(SunshinesBattleacademy.GameItem)

    target =
      SunshinesBattleacademy.Repo.get(SunshinesBattleacademy.GameItem, "")
      |> SunshinesBattleacademy.Repo.preload(:position)
      |> SunshinesBattleacademy.Repo.preload(:target)

    # TODO
    # if target == nil do
    # else
    #   target = normalize_target(elem.target)
    #   new_position = %{x: elem.position[:x] + target[:x], y: elem.position[:y] + target[:y]}
    #   {:ok, %{elem | position: new_position}}
    # end

    # map = for {user_id, _id} <- players do
    #   ConCache.get(:game_map, user_id)
    #   # Use target to calculate a new position for this player
    # end
    # push socket, "state_update", %{map: map}
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    push(socket, "welcome", %{id: socket.assigns[:user_id]})

    {:noreply, socket}
  end

  def handle_in("gotit", %{"nickname" => nickname, "hue" => hue}, socket) do
    {hue, _} = Integer.parse(hue)
    {:ok, id} = Ecto.UUID.dump(socket.assigns[:user_id])

    # Ecto Multi?
    SunshinesBattleacademy.Repo.insert(%SunshinesBattleacademy.GameItem{
      id: id,
      nickname: nickname,
      hue: hue,
      target: %SunshinesBattleacademy.Target{x: 0, y: 0},
      position: %SunshinesBattleacademy.Position{x: 0, y: 0}
    })

    {:noreply, socket}
  end

  def handle_in("movement", payload, socket) do
    {:ok, id} = Ecto.UUID.dump(socket.assigns[:user_id])
    player = SunshinesBattleacademy.Repo.get(SunshinesBattleacademy.GameItem, id)
    #  |> SunshinesBattleacademy.Repo.preload(:position)
    #  |> SunshinesBattleacademy.Repo.preload(:target)

    # Move 
    # %{old_value | target: %{x: payload["target"]["x"], y: payload["target"]["y"]}

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
