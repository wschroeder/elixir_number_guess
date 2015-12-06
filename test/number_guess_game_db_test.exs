defmodule NumberGuessGameDBTest do
  use ExUnit.Case
  alias NumberGuess.Game.State, as: State
  doctest NumberGuess.Game.DB

  test "DB handles full states" do
    with_new_server fn (pid) ->
      %State{guesses: 6, number: _} = NumberGuess.Game.DB.state(pid)
      assert NumberGuess.Game.DB.state(pid, %State{number: 39}) == %State{guesses: 6, number: 39}
      assert NumberGuess.Game.DB.state(pid) == %State{guesses: 6, number: 39}
      assert NumberGuess.Game.DB.state(pid, %State{number: 48, guesses: 3}) == %State{guesses: 3, number: 48}
      assert NumberGuess.Game.DB.state(pid) == %State{guesses: 3, number: 48}
    end
  end

  defp with_new_server(block) do
    {:ok, pid} = GenServer.start NumberGuess.Game.DB, :random
    block.(pid)
    Process.exit(pid, :test_done)
  end
end
