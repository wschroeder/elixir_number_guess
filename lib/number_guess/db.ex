defmodule NumberGuess.DB do
  @moduledoc """
  Generic document storage for the Number Guess game.  It's pretty cheesy, but
  one can pretty much store any single term in this DB.  The only special term
  is :no_state, which just holds the distinction of being the first value the
  DB stores.
  """

  @spec start_link(term()) :: GenServer.on_start()
  @doc "Starts the DB server with an optional document and links it to the current process"
  def start_link(starting_state \\ :no_state) do
    Agent.start_link fn -> starting_state end
  end

  @spec state(GenServer.server()) :: term()
  @doc "Retrieves the current document/term stored in the DB."
  def state(server) do
    Agent.get server, &(&1)
  end

  @spec state(GenServer.server(), term()) :: :ok
  @doc "Stores a document/term in the DB."
  def state(server, new_state) do
    Agent.update server, fn _ -> new_state end
  end
end

