defmodule Accountable.Context do
  @behaviour Plug
  import Plug.Conn

  def init(options), do: options

  def call(conn, []) do
    user = get_user(conn)

    assign(conn, :current_user, user)
  end

  def call(conn, absinthe: plug) do
    context = build_context(conn)
    plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    user = get_user(conn)
    %{current_user: user}
  end

  def get_token(conn) do
    fetch_cookies(conn).req_cookies["AccessToken"]
  end

  def get_user_from_token(token) do
    {:ok, user} = Accountable.user_by_token(token)
    user
  end

  def get_user(conn), do: conn |> get_token() |> get_user_from_token()
end
