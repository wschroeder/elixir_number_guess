defmodule NumberGuess.Engine.State do
  @moduledoc """
  Game state for the NumberGuess game.

  * number    - A number between 1 and 100
  * guesses   - Number of guesses remaining
  * db_server - The server identifier of the DB holding game state
  """

  defstruct number: 1, guesses: 6, db_server: nil

  @type guesses_left :: 0..6
  @type guess_t      :: 1..100
  @type t :: %NumberGuess.Engine.State{
      number:    guess_t(),
      guesses:   guesses_left(),
      db_server: GenServer.server()
  }
end

