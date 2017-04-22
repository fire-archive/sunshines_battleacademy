defmodule IfiresSunshineBattleacademy.Web.PageController do
  use IfiresSunshineBattleacademy.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
