defmodule DrinkingGameWeb.GameLive do
  use DrinkingGameWeb, :live_view

  def mount(_params, _session, socket) do
    socket = socket
    |> assign(:game, DrinkingGame.GameServer.get_current_state())
    |> assign(:cup_drinked, false)

    Phoenix.PubSub.subscribe(DrinkingGame.PubSub, "game_updates")

    {:ok, socket}
  end

  def handle_info({:game_updated, game}, socket) do
    {:noreply, assign(socket, :game, game)}
  end

  def handle_event("increment", _params, socket) do
    DrinkingGame.GameServer.increment()
    {:noreply, socket}
  end
end
