defmodule AccountableTest do
  use ExUnit.Case
  use Accountable.RepoCase
  import Accountable.Factory
  alias Accountable.User

  doctest Accountable

  @user_attributes %{email: "me@example.com", password: "a password"}

  describe "user_by_credentials/1" do
    test "greets the world" do
      user = insert(:user, hashed_password(@user_attributes))

      assert {:ok, auth_user} =
               Accountable.user_by_credentials(
                 @user_attributes[:email],
                 @user_attributes[:password]
               )

      assert auth_user.id == user.id
    end
  end

  describe "user_by_id/1" do
    test "get user by id" do
      user = insert(:user, hashed_password(@user_attributes))
      user_id = user.id

      assert %User{id: ^user_id} = Accountable.user_by_id(user_id)
    end
  end

  describe "create_user/1" do
    test "creates a user" do
      assert {:ok, %User{id: _, email: "created@example.com"}} =
               Accountable.create_user(%{email: "created@example.com", password: "password"})
    end
  end

  describe "token_for_user/2" do
    test "generates a token" do
      user = insert(:user, hashed_password(@user_attributes))
      user_id = user.id

      assert {:ok, _token} = Accountable.token_for_user(user)
    end
  end

  describe "user_by_token/1" do
    test "returns user" do
      user = insert(:user)
      user_id = user.id
      {:ok, token} = Accountable.token_for_user(user)

      assert {:ok, %User{id: ^user_id}} = Accountable.user_by_token(token)
    end

    test "fails with invalid token" do
      assert {:error, _} = Accountable.user_by_token("token")
    end
  end
end
