defmodule NumberGuess.Engine.State do
  @moduledoc """
  Game state for the NumberGuess game.

  * number  - A number between 1 and 100
  * guesses - Number of guesses remaining
  * db_pid  - The pid of the DB holding game state
  """

  defstruct number: 1, guesses: 6, db_pid: nil
end

