defmodule NumberGuess.Game.State do
  @moduledoc """
  Game state for the NumberGuess game.

  * number  - A number between 1 and 100
  * guesses - Number of guesses remaining
  """

  defstruct number: 1, guesses: 6
end

