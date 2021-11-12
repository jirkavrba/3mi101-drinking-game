defmodule DrinkingGameWeb.GameLive do
  use DrinkingGameWeb, :live_view

  def mount(_params, _session, socket) do
    socket = socket
    |> assign(:game, DrinkingGame.GameServer.get_current_state())
    |> assign(:cup_available, false)

    Phoenix.PubSub.subscribe(DrinkingGame.PubSub, "game_updates")

    {:ok, socket}
  end

  def handle_info({:game_updated, game}, socket) do
    new_cup_available = rem(game.counter, game.increments_per_cup) == 0

    socket = socket
    |> assign(:game, game)
    |> assign(:cup_available, socket.assigns.cup_available or new_cup_available)

    {:noreply, socket}
  end

  def handle_event("increment", _params, socket) do
    DrinkingGame.GameServer.increment()
    {:noreply, socket}
  end

  def handle_event("drink_cup", _params, socket) do
    {:noreply, assign(socket, :cup_available, false)}
  end
end
