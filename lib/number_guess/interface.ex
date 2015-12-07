defmodule NumberGuess.Interface do
  def main([]) do
    IO.puts """
    Number Guess is a game in which the computer chooses a number between 1
    and 100, and you have six chances to guess it.  At any time, you may type
    "quit" to exit the game.
    """

    start_game
  end

  defp start_game do
    IO.puts "I am thinking of a number between 1 and 100..."
    game_loop
  end

  defp game_loop do
    {:guesses, guesses_left} = NumberGuess.Engine.get_guesses NumberGuess.Engine
    IO.puts "You have #{guesses_left} guesses."
    IO.gets("What number do you think it is? ")
    |> parse_input
  end

  defp parse_input("quit\n") do
    IO.puts "See you later!"
    exit {:shutdown, 0}
  end

  defp parse_input(input) do
    input
    |> Integer.parse
    |> guess
  end

  defp guess(:error) do
    IO.puts "That is not a number between 1 and 100.  Try again."
    game_loop
  end

  defp guess({number, _}) when number > 0 and number <= 100 do
    handle_guess_response NumberGuess.Engine.guess NumberGuess.Engine, number
  end

  defp guess({number, _}) do
    IO.puts "#{number} is not a number between 1 and 100.  Try again."
    game_loop
  end

  defp handle_guess_response({:guess, number, :you_lose, _}) do
    IO.puts "#{number} is not my number, and since you are out of guesses, YOU LOSE!"
    start_game
  end

  defp handle_guess_response({:guess, number, :you_win, guesses_left}) do
    IO.puts "#{number} is the number I was thinking of!  YOU WIN with #{guesses_left} guesses left!!!"
    start_game
  end

  defp handle_guess_response({:guess, number, :too_high, _}) do
    IO.puts "#{number} is too high."
    game_loop
  end

  defp handle_guess_response({:guess, number, :too_low, _}) do
    IO.puts "#{number} is too low."
    game_loop
  end
end

