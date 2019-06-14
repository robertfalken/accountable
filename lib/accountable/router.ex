defmodule Accountable.Router do
  use Plug.Router
  alias Accountable.Controller

  plug(:match)
  plug(:dispatch)

  post "/authenticate" do
    conn
    |> Controller.call(:authenticate)
  end

  post "/refresh" do
    conn
    |> Controller.call(:refresh)
  end
end
