defmodule SunshinesBattleacademy.Web.ChatChannel do
  use Phoenix.Channel
  require Logger

  def join("chat:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("chat:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("new_msg", %{"body" => body, "user" => user}, socket) do
    broadcast! socket, "new_msg", %{user: user, body: body}
    {:noreply, socket}
  end
end
