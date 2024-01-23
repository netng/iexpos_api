defmodule IexposApiWeb.TestJSON do
  alias IexposApi.Tests.Test

  @doc """
  Renders a list of tests.
  """
  def index(%{tests: tests}) do
    %{data: for(test <- tests, do: data(test))}
  end

  @doc """
  Renders a single test.
  """
  def show(%{test: test}) do
    %{data: data(test)}
  end

  defp data(%Test{} = test) do
    %{
      id: test.id,
      name: test.name
    }
  end
end
