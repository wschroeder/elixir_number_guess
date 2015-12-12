defmodule NumberGuess.DB do
  @moduledoc """
  Generic document storage for the Number Guess game.  It's pretty cheesy, but
  one can pretty much store any single term in this DB.  The only special term
  is :no_state, which just holds the distinction of being the first value the
  DB stores.
  """

  @doc "Starts the DB server with an optional document and links it to the current process"
  @spec start_link(term()) :: GenServer.on_start()
  def start_link(starting_state \\ :no_state) do
    Agent.start_link fn -> starting_state end
  end

  @doc "Retrieves the current document/term stored in the DB."
  @spec state(GenServer.server()) :: term()
  def state(server) do
    Agent.get server, &(&1)
  end

  @doc "Stores a document/term in the DB."
  @spec state(GenServer.server(), term()) :: :ok
  def state(server, new_state) do
    Agent.update server, fn _ -> new_state end
  end
end

