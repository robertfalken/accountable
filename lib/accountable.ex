defmodule Accountable do
  @moduledoc """
  Documentation for Accountable.
  """

  @supported_tokens ~w(access reset_password)
  @repo Application.get_env(:accountable, :ecto_repo)
  @user_schema Application.get_env(:accountable, :user_schema, Accountable.User)

  @spec user_by_credentials(String.t(), String.t()) :: {:ok, struct}
  def user_by_credentials(email, password) do
    user = @repo.get_by!(@user_schema, email: email)
    Argon2.check_pass(user, password)
  end

  def user_by_id(id), do: @repo.get!(@user_schema, id)

  def create_user(attributes) do
    attributes
    |> user_changeset()
    |> @repo.insert()
  end

  defp user_changeset(attributes) do
    attributes = put_password_hash(attributes)
    @user_schema.changeset(@user_schema.__struct__, attributes)
  end

  @spec token_for_user(struct, String.t()) :: {atom, String.t()}
  def token_for_user(user, type \\ "access") do
    with true <- Enum.member?(@supported_tokens, type),
         {:ok, token, _claims} <- Accountable.Guardian.encode_and_sign(user, %{typ: type}) do
      {:ok, token}
    else
      _ ->
        {:error, "Unsupported token type"}
    end
  end

  @spec user_by_token(String.t()) :: {:ok, struct} | {:error, any}
  def user_by_token(token) do
    case Accountable.Guardian.resource_from_token(token, %{"typ" => "access"}) do
      {:ok, user, _claims} ->
        {:ok, user}

      err ->
        err
    end
  end

  defp put_password_hash(%{password: password} = attrs) do
    Map.merge(attrs, Argon2.add_hash(password))
  end
end
