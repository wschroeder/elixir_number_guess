defmodule NumberGuess.Game do
  use GenServer
  alias NumberGuess.Game.State, as: State


  ####
  # External API

  def start_link(db_pid) do
    GenServer.start_link __MODULE__, db_pid
  end

  def get_guesses(pid) do
    GenServer.call pid, :get_guesses
  end

  def guess(pid, number) do
    GenServer.call pid, {:guess, number}
  end


  ####
  # Helpers

  defp ensure_state(:no_state, db_pid), do: new_game_state db_pid
  defp ensure_state(starting_state, _), do: starting_state

  defp new_game_state(db_pid) do
    %State{number: :random.uniform(100), db_pid: db_pid}
  end

  defp judge(guessed_number, number) when guessed_number > number, do: :too_high
  defp judge(guessed_number, number) when guessed_number < number, do: :too_low


  ####
  # GenServer

  def init(db_pid) do
    _ = :random.seed :erlang.now
    starting_state = ensure_state NumberGuess.Game.DB.state(db_pid), db_pid
    {:ok, starting_state}
  end

  def terminate(_reason, current_state = %State{db_pid: db_pid}) do
    _ = NumberGuess.Game.DB.state db_pid, current_state
    :ok
  end

  def handle_call(:get_guesses, _from, current_state = %State{guesses: guesses}) do
    {:reply,
      {:guesses, guesses},
      current_state}
  end

  def handle_call({:guess, guessed_number}, _from, %State{guesses: guesses, number: guessed_number, db_pid: db_pid}) when is_number guessed_number do
    {:reply,
      {:guess, guessed_number, :you_win, guesses - 1},
      new_game_state db_pid}
  end

  def handle_call({:guess, guessed_number}, _from, %State{guesses: 1, number: number, db_pid: db_pid}) when is_number guessed_number do
    {:reply,
      {:guess, guessed_number, :you_lose, number},
      new_game_state db_pid}
  end

  def handle_call({:guess, guessed_number}, _from, %State{guesses: guesses, number: number, db_pid: db_pid}) when is_number guessed_number do
    {:reply,
      {:guess, guessed_number, judge(guessed_number, number), guesses - 1},
      %State{guesses: guesses - 1, number: number, db_pid: db_pid}}
  end

end

