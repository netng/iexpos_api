defmodule IexposApiWeb.Auth.Guardian do
  use Guardian, otp_app: :iexpos_api

  alias IexposApi.V1.Stores.Customers.{Accounts, Account}

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id, "codename" => codename}) do
    # case Accounts.get_account!(id) do
    #   nil -> {:error, :not_found}
    #   resource -> {:ok, resource}
    # end

    with %Account{} = resource <- Accounts.get_account!(id, codename) do
      {:ok, resource}
    else
      nil ->
        {:error, :not_found}

      _ ->
        {:error, :not_found}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  def authenticate(email, password, tenant) do
    tenant = "tenant_" <> String.downcase(tenant)

    with %Account{} = account <- Accounts.get_account_by_email(email, tenant),
         true <- validate_password(password, account.hash_password),
         {:ok, %Account{} = account, token} <- create_token(account, tenant) do
      {:ok, account, token, %{message: "success"}}
    else
      nil ->
        {:error, :unauthorized}

      false ->
        {:error, :unauthorized}

      _ ->
        {:error, :unauthorized}
    end
  end

  # def authenticate(token) do
  #   with {:ok, claims} <- decode_and_verify(token),
  #        {:ok, account} <- resource_from_claims(claims),
  #        {:ok, _old, {token, _claims}} <- refresh(token) do
  #     {:ok, account, token}
  #   end
  # end

  defp validate_password(password, hash_password) do
    Bcrypt.verify_pass(password, hash_password)
  end

  defp create_token(account, tenant) do
    {:ok, token, _claims} = encode_and_sign(account, %{codename: tenant})
    {:ok, account, token}
  end
end
