defmodule NumberGuessGameDBTest do
  use ExUnit.Case
  alias NumberGuess.Game.State, as: State
  doctest NumberGuess.Game.DB

  test "DB handles full states" do
    with_new_server fn (pid) ->
      assert NumberGuess.Game.DB.state(pid) == :no_state

      assert NumberGuess.Game.DB.state(pid, %State{number: 39}) == :ok
      assert NumberGuess.Game.DB.state(pid) == %State{guesses: 6, number: 39, db_pid: nil}

      assert NumberGuess.Game.DB.state(pid, %State{number: 48, guesses: 3}) == :ok
      assert NumberGuess.Game.DB.state(pid) == %State{guesses: 3, number: 48, db_pid: nil}
    end
  end

  defp with_new_server(block) do
    {:ok, pid} = GenServer.start NumberGuess.Game.DB, :no_state
    block.(pid)
    Process.exit(pid, :test_done)
  end
end
