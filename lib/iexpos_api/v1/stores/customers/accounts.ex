defmodule IexposApi.V1.Stores.Customers.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias IexposApi.Repo
  alias IexposApi.V1.Stores.Customers.Account

  @doc """
  Creates an account.

  ## Examples

      iex> create_account(%{field: value}, "tenant_xxx")
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value}, "tenant_xxx")
      {:error, %Ecto.Changeset{}}
  """
  def create_account(attrs \\ %{}, tenant) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert(prefix: tenant)
  end

  def get_user_account(id, tenant) do
    Account
    |> where(id: ^id)
    |> preload([:user])
    |> Repo.one(prefix: tenant)
  end

  @doc """
  Gets a single account by email

  Returns 'nil' if account doest not exist.

  ## Examples

    iex> get_account_by_email(test@gmail.com, tenant_name)
    %Account{}

    iex> get_account_by_email(no_account@gmail.com, tenant_name)
    nil
  """
  def get_account_by_email(email, tenant) do
    Account
    |> where(email: ^email)
    |> Repo.one(prefix: tenant)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id, tenant), do: Repo.get!(Account, id, prefix: tenant)
end
