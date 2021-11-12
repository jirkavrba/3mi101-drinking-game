defmodule DrinkingGame.Game do
  @type t :: %__MODULE__{
    playing: boolean(),
    counter: non_neg_integer(),
    increments_per_cup: non_neg_integer(),
    last_incremented_at: DateTime.t(),
  }

  defstruct [
    playing: false,
    counter: 0,
    increments_per_cup: 5,
    last_incremented_at: DateTime.from_unix(0),
    cooldown: 5 # 5 seconds
  ]
end
