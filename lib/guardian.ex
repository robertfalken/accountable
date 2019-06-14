defmodule Accountable.Guardian do
  use Guardian, otp_app: :accountable

  def subject_for_token(resource, _claims) do
    user_id = to_string(resource.id)
    {:ok, user_id}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    user = Accountable.user_by_id(id)
    {:ok, user}
  end
end
