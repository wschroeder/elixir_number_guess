defmodule NumberGuess.Supervisor do
  @moduledoc """
  This is the supervisor for the Number Guess game.
  """

  use Supervisor

  ####
  # External API

  @doc """
  Starts and links the Number Guess supervisor to the current process.
  """
  @spec start_link() :: Supervisor.on_start()
  def start_link do
    result = {:ok, sup_pid} = Supervisor.start_link __MODULE__, []
    :ok = start_workers sup_pid
    result
  end


  ####
  # Supervisor

  def init(_) do
    supervise [], strategy: :one_for_all
  end

  defp start_workers(sup_pid) do
    {:ok, db_pid}        = Supervisor.start_child sup_pid, worker(NumberGuess.DB, [])
    {:ok, _game_sup_pid} = Supervisor.start_child sup_pid, supervisor(NumberGuess.EngineSupervisor, [db_pid])
    :ok
  end

end

