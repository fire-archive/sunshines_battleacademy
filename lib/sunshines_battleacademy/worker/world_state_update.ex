defmodule SunshinesBattleacademy.Worker.WorldStateUpdate do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    unless state do
      players = ConCache.get(:game_map, :player_list)
      map = for n <- players do
        elem = ConCache.get(:game_map, n)
        tx = elem.payload["target"]["x"] / 10
        ty = elem.payload["target"]["y"] / 10
        length = :math.sqrt((tx*tx) + (ty*ty))
        target = if length > 15 do
          %{x: (tx / length) * 15, y: (ty / length) * 15}
        else
          %{x: tx, y: ty}
        end
      end
      Phoenix.Channel.broadcast! state.socket, "state_update", map
    end
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, div(1000, 10))
  end
end
