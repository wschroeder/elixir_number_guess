# NumberGuess

This is the NumberGuess game!

The computer opponent comes up with a secret number between 1 and 100, and you
get six chances to guess it.


## Escript

This game is designed to be run as an escript.  Use:

  mix escript.build


to produce a "number_guess" script, and enjoy the game!


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add number_guess to your list of dependencies in `mix.exs`:

        def deps do
          [{:number_guess, "~> 0.0.1"}]
        end

  2. Ensure number_guess is started before your application:

        def application do
          [applications: [:number_guess]]
        end
