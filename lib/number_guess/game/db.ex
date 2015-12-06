defmodule NumberGuess.Game.DB do
  use GenServer
  alias NumberGuess.Game.State, as: State

  ####
  # External API

  def start_link(number \\ :random) do
    GenServer.start_link __MODULE__, number
  end

  def state(pid) do
    GenServer.call pid, :get_state
  end

  def state(pid, new_state) do
    GenServer.call pid, {:set_state, new_state}
  end


  ####
  # Helpers

  defp new_game_state(:random) do
    %State{number: :random.uniform 100}
  end

  defp new_game_state(number) do
    %State{number: number}
  end


  ####
  # GenServer

  def init(number) do
    _ = :random.seed :erlang.now
    {:ok, new_game_state number}
  end

  def handle_call(:get_state, _from, current_state) do
    {:reply, current_state, current_state}
  end

  def handle_call({:set_state, new_state}, _from, _old_state) do
    {:reply, new_state, new_state}
  end

end

