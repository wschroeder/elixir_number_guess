defmodule NumberGuess.EngineSupervisor do
  @moduledoc """
  This is the supervisor for the Number Guess game engine.
  """

  use Supervisor

  ####
  # External API

  @doc """
  Starts and links the Number Guess game engine supervisor to the current
  process.  Provide the pid of the Number Guess DB server.
  """
  @spec start_link(GenServer.server()) :: Supervisor.on_start()
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

