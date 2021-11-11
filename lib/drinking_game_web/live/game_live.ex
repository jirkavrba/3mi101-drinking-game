defmodule DrinkingGameWeb.GameLive do
  use DrinkingGameWeb, :live_view

  def mount(conn, session, socket) do
    {:ok, socket}
  end
end
