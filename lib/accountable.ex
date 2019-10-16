defmodule Accountable do
  @moduledoc """
  Documentation for Accountable.
  """

  @supported_tokens ~w(access reset_password)

  @spec user_by_credentials(String.t(), String.t()) :: {:ok, struct}
  def user_by_credentials(email, password) do
    case repo.get_by!(user_schema, email: email) do
      %{password_hash: nil} ->
        {:error, "Authentication disabled"}

      user ->
        Argon2.check_pass(user, password)
    end
  end

  def user_by_id(id), do: repo.get(user_schema, id)

  def user_by_email(email), do: repo.get_by(user_schema(), email: email)

  def create_user(attributes) do
    attributes
    |> user_changeset()
    |> repo.insert()
  end

  defp user_changeset(attributes) do
    attributes = put_password_hash(attributes)
    user_schema.changeset(user_schema.__struct__, attributes)
  end

  @spec token_for_user(struct, String.t()) :: {atom, String.t()}
  def token_for_user(user, type \\ "access") do
    with true <- Enum.member?(@supported_tokens, type),
         {:ok, token, _claims} <- claims(user, type) do
      {:ok, token}
    else
      _ ->
        {:error, "Unsupported token type"}
    end
  end

  @spec user_by_token(String.t()) :: {:ok, struct} | {:error, any}
  def user_by_token(token, type \\ "access") do
    case Accountable.Guardian.resource_from_token(token, %{"typ" => type}) do
      {:ok, user, _claims} ->
        {:ok, user}

      err ->
        err
    end
  end

  def reset_password(token, new_password) do
    {:ok, user} = user_by_token(token, "reset_password")
    attributes = %{password: new_password} |> put_password_hash()
    changeset = user_schema.changeset(user, attributes)
    repo.update!(changeset)
  end

  def put_password_hash(%{password: password} = attrs) do
    Map.merge(attrs, Argon2.add_hash(password))
  end

  def put_password_hash(attrs), do: attrs

  def repo, do: Application.get_env(:accountable, :ecto_repo)
  def user_schema, do: Application.get_env(:accountable, :user_schema, Accountable.User)

  def claims(user, type \\ "access") do
    claims_fn = Application.get_env(:accountable, :claims, &default_claims/2)
    claims_fn.(user, type)
  end

  def default_claims(user, type \\ "access") do
    Accountable.Guardian.encode_and_sign(
      user,
      %{
        "typ" => type
      }
    )
  end
end
