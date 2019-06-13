defmodule AccountableTest do
  use ExUnit.Case
  use Accountable.RepoCase
  import Accountable.Factory
  alias Accountable.User

  doctest Accountable

  @user_attributes %{email: "me@example.com", password: "a password"}

  describe "user_by_credentials/1" do
    test "greets the world" do
      user_params = @user_attributes |> hashed_password()
      user = insert(:user, user_params)

      assert {:ok, authenticated_user} =
               Accountable.user_by_credentials(%{
                 email: @user_attributes[:email],
                 password: @user_attributes[:password]
               })

      assert user.id == authenticated_user.id
    end
  end

  describe "user_by_id/1" do
    test "get user by id" do
      user_id = insert(:user).id

      assert %User{id: ^user_id} = Accountable.user_by_id(user_id)
    end
  end

  describe "create_user/1" do
    test "creates a user" do
      user = Accountable.create_user(@user_attributes)
    end
  end
end
