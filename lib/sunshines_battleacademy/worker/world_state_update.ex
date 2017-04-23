defmodule SunshinesBattleacademy.Worker.WorldStateUpdate do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    IO.inspect "work"
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, div(1000, 20)) # 60 times per second
  end
end
