defmodule DrinkingGameWeb.GameSettingsController do
  use DrinkingGameWeb, :controller

  alias DrinkingGame.GameServer

  def index(conn, _params) do
    conn
    |> assign(:current_state, GameServer.get_current_state())
    |> render("index.html")
  end

  def save(conn, params) do
    with {:ok, params} <- validate_save_params(params) do
      GameServer.save_settings(params)
      redirect conn, to: Routes.game_path(conn, :index)
    else
      _ -> redirect conn, to: Routes.game_settings_path(conn, :index)
    end
  end

  defp validate_save_params(params) do
    with {increments_per_cup, _} <- Integer.parse(params["increments_per_cup"]),
         {cooldown, _} <- Integer.parse(params["cooldown"]) do
      Vex.validate(
        %{
          increments_per_cup: increments_per_cup,
          cooldown: cooldown
        },
        increments_per_cup: [number: [greater_than: 0, less_than_or_equal_to: 5]],
        cooldown: [number: [greater_than: 0, less_than_or_equal_to: 30]]
      )
    end
  end
end
