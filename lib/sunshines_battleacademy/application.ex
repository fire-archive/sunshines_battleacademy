defmodule SunshinesBattleacademy.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(SunshinesBattleacademy.Repo, []),
      # Start the endpoint when the application starts
      supervisor(SunshinesBattleacademy.Web.Endpoint, []),
      # Work state updater
      worker(SunshinesBattleacademy.Worker.WorldStateUpdate, []),
      # Start the ets 
      supervisor(ConCache, [[ttl: 0], [ name: :game_map]], [id: "con_cache_game_map"]),
      supervisor(ConCache, [[], [ name: :hash_table]], [id: "con_cache_hash_table"]),
      supervisor(ConCache, [[], [ name: :voxel]], [id: "con_cache_voxel"]),
      # Start your own worker by calling: SunshinesBattleacademy.Worker.start_link(arg1, arg2, arg3)
      # worker(SunshinesBattleacademy.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SunshinesBattleacademy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
