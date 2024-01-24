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

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
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
end
