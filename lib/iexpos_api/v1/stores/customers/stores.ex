defmodule IexposApi.V1.Stores.Customers.Stores do
  @moduledoc """
  The Stores context.
  """

  import Ecto.Query, warn: false

  alias IexposApi.V1.Stores.Customers.{
    Account,
    Accounts,
    Store,
    User,
    Users
  }

  alias IexposApi.Repo
  alias IexposApi.V1.Helper.TenantActions

  @doc """
  Creates a store (we call it as tenant).
  Will create a new schema with prefix tenant_[code].

  This action is transactional process, so if a transaction fail, we rolled back it.

  ## Examples

      iex> create_store(%{field: value})
      {:ok, %store{}}

      iex> create_store(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_store(store, account, user) do
    store_changeset = Store.changeset(%Store{}, store)

    if store_changeset.valid? do
      codename = Ecto.Changeset.get_field(store_changeset, :codename)
      tenant = "tenant_" <> String.downcase(codename)

      Ecto.Multi.new()
      |> Ecto.Multi.run(:create_tenant, fn _, _ ->
        TenantActions.create_tenant_database_schema(codename)
      end)
      |> Ecto.Multi.insert(:insert_store, store_changeset)
      |> Ecto.Multi.run(:insert_and_build_user_account, fn _, _ ->
        insert_and_build_user_account(account, user, tenant)
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{create_tenant: _codename, insert_store: changeset}} ->
          {:ok, changeset, %{message: "pendaftaran akun berhasil"}}

        {:error, :insert_store, changeset, _} ->
          {:error, changeset}

        {:error, :insert_account, changeset, _} ->
          {:error, changeset}

        {:error, :insert_and_build_user_account, changeset, _} ->
          {:error, changeset}
      end
    else
      {:error, store_changeset}
    end
  end

  def is_exists?(codename) do
    Store
    |> where(codename: ^String.downcase(codename))
    |> Repo.exists?()
  end

  def get_store_by_codename(codename) do
    Store
    |> where(codename: ^codename)
    |> Repo.one()
  end

  defp insert_and_build_user_account(account_params, user_params, tenant) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params, tenant),
         {:ok, %User{} = _user} <- Users.create_user(account, user_params, tenant) do
      {:ok, Accounts.get_user_account(account.id, tenant)}
    end
  end
end
