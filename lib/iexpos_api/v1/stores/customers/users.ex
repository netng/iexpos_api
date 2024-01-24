defmodule IexposApi.V1.Stores.Customers.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false

  alias IexposApi.Repo
  alias IexposApi.V1.Stores.Customers.User

  @doc """
  Creates a User.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_user(account, attrs, tenant) do
    account
    |> Ecto.build_assoc(:user)
    |> User.changeset(attrs)
    |> Repo.insert(prefix: tenant)
  end
end
