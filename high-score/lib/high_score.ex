defmodule HighScore do
  @default_score 0

  def new(), do: %{}
  def add_player(scores, name, score \\ @default_score), do: Map.put(scores, name, score)
  def remove_player(scores, name), do: Map.delete(scores, name)

  def reset_score(scores, name),
    do: Map.update(scores, name, @default_score, fn _ -> @default_score end)

  def update_score(scores, name, score),
    do: Map.update(scores, name, @default_score + score, &(&1 + score))

  def get_players(scores), do: Map.keys(scores)
end
