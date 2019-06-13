defmodule Accountable.Factory do
  use ExMachina.Ecto, repo: Accountable.TestRepo

  def user_factory do
    %Accountable.User{
      email: sequence(:email, &"user-#{&1}@example.com"),
      password: "password"
    }
  end

  def hashed_password(%{password: password} = attrs) do
    Map.merge(attrs, Argon2.add_hash(password))
  end
end
