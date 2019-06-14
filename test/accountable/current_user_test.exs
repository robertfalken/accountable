defmodule Accountable.CurrentUserTest do
  use ExUnit.Case
  use Plug.Test
  use Accountable.RepoCase
  import Accountable.Factory
  import Plug.Conn
  alias Accountable.User
  alias Accountable.CurrentUser

  describe "assigns" do
    test "assigns current_user" do
      user = insert(:user)
      user_id = user.id
      {:ok, token} = Accountable.token_for_user(user)
      conn = conn(:get, "/") |> put_req_cookie("AccessToken", token) |> CurrentUser.call([])

      assert %{current_user: %User{id: ^user_id}} = conn.assigns
    end
  end

  describe "absinthe context" do
    test "assigns current_user" do
      user = insert(:user)
      user_id = user.id
      {:ok, token} = Accountable.token_for_user(user)

      conn =
        conn(:get, "/")
        |> put_req_cookie("AccessToken", token)
        |> CurrentUser.call(absinthe: Absinthe.Plug)

      assert %User{id: ^user_id} = conn.private.absinthe.context.current_user
    end
  end
end
