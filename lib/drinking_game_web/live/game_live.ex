defmodule DrinkingGameWeb.GameLive do
  use DrinkingGameWeb, :live_view

  def mount(_params, session, socket) do
    {:ok, socket}
  end
end
