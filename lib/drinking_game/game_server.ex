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

  # Internal interface
  def handle_call(:get_current_state, _from, state) do
    {:reply, state.game, state}
  end
end
