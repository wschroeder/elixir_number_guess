defmodule NumberGuess.GameSup do
  use Supervisor

  ####
  # External API

  def start_link do
    Supervisor.start_link __MODULE__, :random
  end


  ####
  # Supervisor

  def init(starting_number) do
    children = [
      worker(NumberGuess.Game, [starting_number])
    ]

    supervise children, strategy: :one_for_one
  end

end

