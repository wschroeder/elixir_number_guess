defmodule NumberGuess.DB do
  @moduledoc """
  Generic document storage for the Number Guess game.  It's pretty cheesy, but
  one can pretty much store any single term in this DB.  The only special term
  is :no_state, which just holds the distinction of being the first value the
  DB stores.
  """

  use GenServer

  ####
  # External API

  @spec start_link(term()) :: GenServer.on_start()
  @doc "Starts the DB server with an optional document and links it to the current process"
  def start_link(starting_state \\ :no_state) do
    GenServer.start_link __MODULE__, starting_state
  end

  @spec state(pid()) :: term()
  @doc "Retrieves the current document/term stored in the DB."
  def state(pid) do
    GenServer.call pid, :get_state
  end

  @spec state(pid(), term()) :: :ok
  @doc "Stores a document/term in the DB."
  def state(pid, new_state) do
    GenServer.cast pid, {:set_state, new_state}
  end


  ####
  # GenServer

  def handle_call(:get_state, _from, current_state) do
    {:reply, current_state, current_state}
  end

  def handle_cast({:set_state, new_state}, _old_state) do
    {:noreply, new_state}
  end

end

