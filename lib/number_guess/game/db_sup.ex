defmodule NumberGuess.Game.DBSup do
  @moduledoc """
  This is the supervisor for the Number Guess game DB.
  """

  use Supervisor

  ####
  # External API

  @spec start_link() :: Supervisor.on_start()
  @doc """
  Starts and links the Number Guess game DB supervisor to the current process.
  """
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
    {:ok, db_pid}        = Supervisor.start_child sup_pid, worker(NumberGuess.Game.DB, [])
    {:ok, _game_sup_pid} = Supervisor.start_child sup_pid, supervisor(NumberGuess.GameSup, [db_pid])
    :ok
  end

end

