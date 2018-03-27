defmodule SunshinesBattleacademy.Web.PageController do
  use SunshinesBattleacademy.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
