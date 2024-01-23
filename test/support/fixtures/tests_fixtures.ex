defmodule IexposApi.TestsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `IexposApi.Tests` context.
  """

  @doc """
  Generate a test.
  """
  def test_fixture(attrs \\ %{}) do
    {:ok, test} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> IexposApi.Tests.create_test()

    test
  end
end
