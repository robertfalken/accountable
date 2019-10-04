defmodule Accountable.Plugs.RouterTest do
  use ExUnit.Case
  use Plug.Test
  use Accountable.RepoCase
  import Accountable.Factory
  import Plug.Conn
  alias Accountable.Router

  describe "/authenticate" do
    test "is successful with valid credentials" do
      params = %{email: "me@example.com", password: "pass"} |> hashed_password()
      user = insert(:user, params)

      conn =
        conn(:post, "/authenticate", %{email: "me@example.com", password: "pass"})
        |> Router.call([])

      assert conn.status == 200
      assert %{"AccessToken" => %{value: token}} = conn.resp_cookies
    end

    test "is unauthorized with invalid credentials" do
      params = %{email: "me@example.com", password: "pass"} |> hashed_password()
      user = insert(:user, params)

      conn =
        conn(:post, "/authenticate", %{email: "me@example.com", password: "wrong password"})
        |> Router.call([])

      assert conn.status == 401
      assert conn.resp_cookies["AccessToken"] == nil
    end
  end

  describe "/refresh" do
    test "sets a new access token cookie" do
      params = %{email: "me@example.com", password: "pass"} |> hashed_password()
      user = insert(:user, params)
      {:ok, token} = Accountable.token_for_user(user)

      conn =
        conn(:post, "/refresh", %{})
        |> put_req_cookie("AccessToken", token)
        |> Router.call([])

      assert conn.status == 200
      assert conn.resp_cookies["AccessToken"].value != token
    end

    test "clears invalid access token" do
      conn =
        conn(:post, "/refresh", %{})
        |> put_req_cookie("AccessToken", "invalid token")
        |> Router.call([])

      assert conn.status == 401
      assert fetch_cookies(conn).cookies["AccessToken"] == nil
    end
  end

  describe "/logout" do
    test "clears access token" do
      params = %{email: "me@example.com", password: "pass"} |> hashed_password()
      user = insert(:user, params)
      {:ok, token} = Accountable.token_for_user(user)

      conn =
        conn(:post, "/logout", %{})
        |> put_req_cookie("AccessToken", token)
        |> Router.call([])

      assert conn.status == 200
      assert fetch_cookies(conn).cookies["AccessToken"] == nil
    end
  end
end
