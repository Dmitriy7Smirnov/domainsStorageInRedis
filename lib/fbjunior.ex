defmodule FBJunior do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("FBJunior started...", [])

    web_port = Application.get_env(:fbjunior, :web_port)

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Router, [], port: web_port),
      {Redix, name: :redix}
    ]

    Supervisor.start_link(children, [strategy: :one_for_one, name: FB.Supervisor])
  end
end
