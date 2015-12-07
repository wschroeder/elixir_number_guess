defmodule NumberGuess do
  @moduledoc """
  In the Number Guess game, a computer opponent picks a number between 1 and
  100, and the human player must guess this number in six tries.

  This is the application surrounding the game.  The supervision tree looks
  like this:

      Supervisor -> DB
                 -> Engine.Supervisor -> Engine
  """
  use Application

  def start(_type, _args) do
    NumberGuess.Supervisor.start_link
  end
end
