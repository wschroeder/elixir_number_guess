defmodule NumberGuess do
  @moduledoc """
  In the Number Guess game, a computer opponent picks a number between 1 and
  100, and the human player must guess this number in six tries.

  This is the application surrounding the game.
  """
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      worker(NumberGuess.Game.DBSup, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NumberGuess.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
