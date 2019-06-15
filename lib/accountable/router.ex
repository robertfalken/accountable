defmodule Accountable.Router do
  use Plug.Router
  alias Accountable.Controller

  plug(:match)
  plug(:dispatch)

  post("/authenticate", do: Controller.call(conn, :authenticate))
  post("/refresh", do: Controller.call(conn, :refresh))
  post("/logout", do: Controller.call(conn, :logout))
end
