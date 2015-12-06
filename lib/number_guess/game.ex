defmodule NumberGuess.Game do
  use GenServer
  alias NumberGuess.Game.State, as: State


  ####
  # External API

  def start_link(starting_number \\ :random) do
    GenServer.start_link(__MODULE__, starting_number)
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
  end

  def get_guesses(pid) do
    GenServer.call(pid, :get_guesses)
  end

  def guess(pid, number) do
    GenServer.call(pid, {:guess, number})
  end


  ####
  # Helpers

  defp new_game_state(:random) do
    %State{number: :random.uniform 100}
  end

  defp new_game_state(number) do
    %State{number: number}
  end

  defp judge(guessed_number, number) when guessed_number > number, do: :too_high
  defp judge(guessed_number, number) when guessed_number < number, do: :too_low


  ####
  # GenServer

  def init(number) do
    _ = :random.seed :erlang.now
    {:ok, new_game_state number}
  end

  def handle_call(:get_guesses, _from, state = %State{guesses: guesses}) do
    {:reply,
      {:guesses, guesses},
      state}
  end

  def handle_call({:guess, guessed_number}, _from, %State{guesses: guesses, number: guessed_number}) when is_number guessed_number do
    {:reply,
      {:guess, guessed_number, :you_win, guesses - 1},
      new_game_state :random}
  end

  def handle_call({:guess, guessed_number}, _from, %State{guesses: 1, number: number}) when is_number guessed_number do
    {:reply,
      {:guess, guessed_number, :you_lose, number},
      new_game_state :random}
  end

  def handle_call({:guess, guessed_number}, _from, %State{guesses: guesses, number: number}) when is_number guessed_number do
    {:reply,
      {:guess, guessed_number, judge(guessed_number, number), guesses - 1},
      %State{guesses: guesses - 1, number: number}}
  end

  def handle_cast(:stop, state) do
    {:stop, :requested_stop, state}
  end

end

