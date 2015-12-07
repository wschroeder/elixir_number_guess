defmodule NumberGuess.Game.DB do
  use GenServer

  ####
  # External API

  def start_link(starting_state \\ :no_state) do
    GenServer.start_link __MODULE__, starting_state
  end

  def state(pid) do
    GenServer.call pid, :get_state
  end

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

