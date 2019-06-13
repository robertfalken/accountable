defmodule Accountable do
  @moduledoc """
  Documentation for Accountable.
  """

  @repo Accountable.TestRepo
  @user_schema Accountable.User

  def user_by_credentials(%{email: email, password: password}) do
    user = @repo.get_by!(@user_schema, email: email)
    Argon2.check_pass(user, password)
  end

  def user_by_id(id), do: @repo.get!(@user_schema, id)

  def create_user(attrs) do
    @repo.insert(@user_schema, attrs)
  end
end
