defmodule NumberGuessGameTest do
  use ExUnit.Case
  doctest NumberGuess.Game

  test "Play a winning game" do
    winning_number = 20
    with_new_server winning_number, fn (pid) ->
      assert NumberGuess.Game.get_guesses(pid) == {:guesses, 6}
      assert NumberGuess.Game.guess(pid, 50) == {:guess, 50, :too_high, 5}
      assert NumberGuess.Game.get_guesses(pid) == {:guesses, 5}
      assert NumberGuess.Game.guess(pid, 10) == {:guess, 10, :too_low, 4}
      assert NumberGuess.Game.get_guesses(pid) == {:guesses, 4}
      assert NumberGuess.Game.guess(pid, winning_number) == {:guess, winning_number, :you_win, 3}
      assert NumberGuess.Game.get_guesses(pid) == {:guesses, 6}
    end
  end

  test "Play a losing game" do
    winning_number = 30
    with_new_server winning_number, fn (pid) ->
      (6..2) |> Enum.each fn (expected_guesses) ->
        assert NumberGuess.Game.get_guesses(pid) == {:guesses, expected_guesses}
        assert NumberGuess.Game.guess(pid, 50) == {:guess, 50, :too_high, expected_guesses - 1}
      end
      assert NumberGuess.Game.get_guesses(pid) == {:guesses, 1}
      assert NumberGuess.Game.guess(pid, 50) == {:guess, 50, :you_lose, winning_number}
      assert NumberGuess.Game.get_guesses(pid) == {:guesses, 6}
    end
  end

  defp with_new_server(number, block) do
    {:ok, pid} = NumberGuess.Game.start_link number
    block.(pid)
    NumberGuess.Game.stop pid
  end
end
