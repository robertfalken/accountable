defmodule Accountable.RepoCase do
  use ExUnit.CaseTemplate

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Accountable.TestRepo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Accountable.TestRepo, {:shared, self()})
    end

    :ok
  end
end
