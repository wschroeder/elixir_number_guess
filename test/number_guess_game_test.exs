defmodule NumberGuessGameTest do
  use ExUnit.Case
  alias NumberGuess.Engine.State, as: State
  doctest NumberGuess.Engine

  test "Play a winning game" do
    winning_number = 20
    with_new_server winning_number, fn (pid) ->
      assert NumberGuess.Engine.get_guesses(pid) == {:guesses, 6}
      assert NumberGuess.Engine.guess(pid, 50) == {:guess, 50, :too_high, 5}
      assert NumberGuess.Engine.get_guesses(pid) == {:guesses, 5}
      assert NumberGuess.Engine.guess(pid, 10) == {:guess, 10, :too_low, 4}
      assert NumberGuess.Engine.get_guesses(pid) == {:guesses, 4}
      assert NumberGuess.Engine.guess(pid, winning_number) == {:guess, winning_number, :you_win, 3}
      assert NumberGuess.Engine.get_guesses(pid) == {:guesses, 6}
    end
  end

  test "Play a losing game" do
    winning_number = 30
    with_new_server winning_number, fn (pid) ->
      (6..2) |> Enum.each fn (expected_guesses) ->
        assert NumberGuess.Engine.get_guesses(pid) == {:guesses, expected_guesses}
        assert NumberGuess.Engine.guess(pid, 50) == {:guess, 50, :too_high, expected_guesses - 1}
      end
      assert NumberGuess.Engine.get_guesses(pid) == {:guesses, 1}
      assert NumberGuess.Engine.guess(pid, 50) == {:guess, 50, :you_lose, winning_number}
      assert NumberGuess.Engine.get_guesses(pid) == {:guesses, 6}
    end
  end

  defp with_new_server(number, block) do
    {:ok, db_pid}   = GenServer.start NumberGuess.DB, nil
    :ok             = NumberGuess.DB.state db_pid, %State{number: number, db_pid: db_pid}
    {:ok, game_pid} = GenServer.start NumberGuess.Engine, db_pid

    block.(game_pid)

    Process.exit(game_pid, :test_done)
    Process.exit(db_pid, :test_done)
  end
end
