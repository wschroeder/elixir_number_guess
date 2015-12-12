defmodule NumberGuess.Engine do
  @moduledoc """
  This is the main engine for the Number Guess game.  It understands how to
  pick a number between 1 and 100, judge a winning guess, declare a losing
  game if the player runs out of guesses, and start new games after games end.
  """

  use GenServer
  alias NumberGuess.Engine.State, as: State


  ####
  # External API
  @type guesses_left :: 0..6
  @type guess_t      :: 1..100
  @type judgement    :: :you_win | :you_lose | :too_high | :too_low

  @doc "Starts the Game server with its dependent DB and links it to the current process"
  @spec start_link(GenServer.server()) :: GenServer.on_start()
  def start_link(db_server) do
    GenServer.start_link __MODULE__, db_server, name: NumberGuess.Engine
  end

  @doc "Returns the number of guesses left in the current game"
  @spec get_guesses(GenServer.server()) :: {:guesses, guesses_left()}
  def get_guesses(server) do
    GenServer.call server, :get_guesses
  end

  @doc "Submits a guess to the game server."
  @spec guess(GenServer.server(), guess_t()) :: {:guess, guess_t(), judgement(), guesses_left()}
  def guess(server, number) do
    GenServer.call server, {:guess, number}
  end


  ####
  # Helpers

  defp ensure_state(:no_state, db_server), do: new_game_state db_server
  defp ensure_state(starting_state, _), do: starting_state

  defp new_game_state(db_server) do
    %State{number: :random.uniform(100), db_server: db_server}
  end

  defp judge(guessed_number, number) when guessed_number > number, do: :too_high
  defp judge(guessed_number, number) when guessed_number < number, do: :too_low


  ####
  # GenServer

  def init(db_server) do
    _ = :random.seed :erlang.now
    starting_state = ensure_state NumberGuess.DB.state(db_server), db_server
    {:ok, starting_state}
  end

  def terminate(_reason, current_state = %State{db_server: db_server}) do
    :ok = NumberGuess.DB.state db_server, current_state
  end

  def handle_call(:get_guesses, _from, current_state = %State{guesses: guesses}) do
    {:reply,
      {:guesses, guesses},
      current_state}
  end

  def handle_call({:guess, guessed_number}, _from, %State{guesses: guesses, number: guessed_number, db_server: db_server}) when is_number guessed_number do
    {:reply,
      {:guess, guessed_number, :you_win, guesses - 1},
      new_game_state db_server}
  end

  def handle_call({:guess, guessed_number}, _from, %State{guesses: 1, number: number, db_server: db_server}) when is_number guessed_number do
    {:reply,
      {:guess, guessed_number, :you_lose, number},
      new_game_state db_server}
  end

  def handle_call({:guess, guessed_number}, _from, %State{guesses: guesses, number: number, db_server: db_server}) when is_number guessed_number do
    {:reply,
      {:guess, guessed_number, judge(guessed_number, number), guesses - 1},
      %State{guesses: guesses - 1, number: number, db_server: db_server}}
  end
end

