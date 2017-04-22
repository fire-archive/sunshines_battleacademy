defmodule SunshinesBattleacademy.Web.LobbyChannel do
  use Phoenix.Channel
  require Logger

  # handles the special `"lobby"` subtopic
  def join("room:lobby", _auth_message, socket) do
    {:ok, socket}
  end

  def handle_in(echo, socket) do
    {:reply, {:ok, echo}, socket}
  end
end
