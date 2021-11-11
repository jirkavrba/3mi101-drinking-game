defmodule DrinkingGameWeb.GameLive do
  use DrinkingGameWeb, :live_view

  def mount(_params, _session, socket) do
    socket = socket
    |> assign(:game, DrinkingGame.GameServer.get_current_state())
    |> assign(:cup_drinked, false)

    {:ok, socket}
  end
end
