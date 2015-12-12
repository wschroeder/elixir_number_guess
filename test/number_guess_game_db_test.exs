defmodule NumberGuessGameDBTest do
  use ExUnit.Case
  alias NumberGuess.Engine.State, as: State
  doctest NumberGuess.DB

  test "DB handles full states" do
    with_new_server fn (pid) ->
      assert NumberGuess.DB.state(pid) == :no_state

      assert NumberGuess.DB.state(pid, %State{number: 39}) == :ok
      assert NumberGuess.DB.state(pid) == %State{guesses: 6, number: 39, db_server: nil}

      assert NumberGuess.DB.state(pid, %State{number: 48, guesses: 3}) == :ok
      assert NumberGuess.DB.state(pid) == %State{guesses: 3, number: 48, db_server: nil}
    end
  end

  defp with_new_server(block) do
    {:ok, pid} = NumberGuess.DB.start_link
    block.(pid)
    Process.exit(pid, :test_done)
  end
end
