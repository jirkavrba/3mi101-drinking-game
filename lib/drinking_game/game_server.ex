defmodule DrinkingGame.GameServer do
  use GenServer

  def init(_opts) do
    {:ok, %{game: %DrinkingGame.Game{}}}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_current_state() do
    GenServer.call(__MODULE__, :get_current_state)
  end

  def save_settings(params) do
    GenServer.cast(__MODULE__, {:save_settings, params})
  end

  # Internal interface
  def handle_call(:get_current_state, _from, state) do
    {:reply, state.game, state}
  end

  def handle_cast({:save_settings, params}, state) do
    game = state.game
    |> Map.put(:increments_per_cup, params.increments_per_cup)
    |> Map.put(:cooldown, params.cooldown * 1000)

    {:noreply, %{state | game: game}}
  end
end
