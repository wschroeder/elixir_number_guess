defmodule NumberGuess.EngineSupervisor do
  @moduledoc """
  This is the supervisor for the Number Guess game engine.
  """

  use Supervisor

  ####
  # External API

  @spec start_link(pid()) :: Supervisor.on_start()
  @doc """
  Starts and links the Number Guess game engine supervisor to the current
  process.  Provide the pid of the Number Guess DB server.
  """
  def start_link(db_pid) do
    Supervisor.start_link __MODULE__, db_pid
  end


  ####
  # Supervisor

  def init(db_pid) do
    children = [
      worker(NumberGuess.Engine, [db_pid])
    ]

    supervise children, strategy: :one_for_all
  end

end

