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
  @type guess_response :: {:you_lose, State.guess_t()}
                        | {:you_win, State.guesses_left()}
                        | :too_low
                        | :too_high

  @doc "Starts the Game server with its dependent DB and links it to the current process"
  @spec start_link(GenServer.server()) :: GenServer.on_start()
  def start_link(db_server) do
    GenServer.start_link __MODULE__, db_server, name: NumberGuess.Engine
  end

  @doc "Returns the number of guesses left in the current game"
  @spec get_guesses(GenServer.server()) :: State.guesses_left()
  def get_guesses(server) do
    GenServer.call server, :get_guesses
  end

  @doc "Submits a guess to the game server."
  @spec guess(GenServer.server(), State.guess_t()) :: guess_response()
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

  def terminate(_reason, current_state) do
    :ok = NumberGuess.DB.state current_state.db_server, current_state
  end

  def handle_call(:get_guesses, _from, current_state) do
    {:reply, current_state.guesses, current_state}
  end

  @spec handle_call({:guess, State.guess_t()}, GenServer.from, State.t()) :: {:reply, guess_response(), State.t()}
  def handle_call({:guess, guessed_number}, _from, current_state = %State{number: guessed_number}) when is_number guessed_number do
    response  = {:you_win, current_state.guesses - 1}
    new_state = new_game_state current_state.db_server
    {:reply, response, new_state}
  end

  def handle_call({:guess, guessed_number}, _from, current_state = %State{guesses: 1}) when is_number guessed_number do
    response  = {:you_lose, current_state.number}
    new_state = new_game_state current_state.db_server
    {:reply, response, new_state}
  end

  def handle_call({:guess, guessed_number}, _from, current_state) when is_number guessed_number do
    response  = judge guessed_number, current_state.number
    new_state = %{current_state | guesses: current_state.guesses - 1}
    {:reply, response, new_state}
  end
end

