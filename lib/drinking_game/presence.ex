defmodule DrinkingGame.Presence do
  use Phoenix.Presence, otp_app: :drinking_game, pubsub_server: DrinkingGame.PubSub
end
