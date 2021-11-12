defmodule DrinkingGame.GameServer do
  use GenServer

  def init(_opts) do
    {:ok, %{game: %DrinkingGame.Game{last_incremented_at: DateTime.utc_now()}}}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_current_state() do
    GenServer.call(__MODULE__, :get_current_state)
  end

  def start_game() do
    GenServer.cast(__MODULE__, :start_game)
  end

  def stop_game() do
    GenServer.cast(__MODULE__, :stop_game)
  end

  def save_settings(params) do
    GenServer.cast(__MODULE__, {:save_settings, params})
  end

  def increment() do
    GenServer.cast(__MODULE__, :increment)
  end

  # Internal interface

  def handle_call(:get_current_state, _from, state) do
    {:reply, state.game, state}
  end

  def handle_cast(:start_game, state) do
    game = state.game
    |> Map.put(:playing, true)
    |> Map.put(:counter, 0)

    broadcast_game_update(game)

    {:noreply, %{state | game: game}}
  end

  def handle_cast(:stop_game, state) do
    game = state.game
    |> Map.put(:playing, false)
    |> Map.put(:counter, 0)

    broadcast_game_update(game)

    {:noreply, %{state | game: game}}
  end

  def handle_cast({:save_settings, params}, state) do
    game = state.game
    |> Map.put(:increments_per_cup, params.increments_per_cup)
    |> Map.put(:cooldown, params.cooldown)

    broadcast_game_update(game)

    {:noreply, %{state | game: game}}
  end

  def handle_cast(:increment, state) do
    diff = DateTime.diff(DateTime.utc_now(), state.game.last_incremented_at)

    if diff >= state.game.cooldown do
      game = state.game
      |> Map.put(:last_incremented_at, DateTime.utc_now())
      |> Map.put(:counter, state.game.counter + 1)

      broadcast_game_update(game)

      {:noreply, %{state | game: game}}
    else
      {:noreply, state}
    end
  end

  defp broadcast_game_update(game) do
    Phoenix.PubSub.broadcast!(DrinkingGame.PubSub, "game_updates", {:game_updated, game})
  end
end
