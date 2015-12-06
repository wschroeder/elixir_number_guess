defmodule NumberGuess.GameSup do
  use Supervisor

  ####
  # External API

  def start_link(db_pid) do
    Supervisor.start_link __MODULE__, db_pid
  end


  ####
  # Supervisor

  def init(db_pid) do
    children = [
      worker(NumberGuess.Game, [db_pid])
    ]

    supervise children, strategy: :one_for_all
  end

end

