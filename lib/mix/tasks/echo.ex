defmodule Mix.Tasks.Echo do
  @moduledoc "Printed when the user request `mix help echo`"
  @shortdoc "Echoes arguments"

  use Mix.Task

  def run(args) do
    Mix.shell().info(Enum.join(args, " "))
  end
end
