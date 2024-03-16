defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]
  def random_planet_class(), do: Enum.random(@planetary_classes)
  def random_ship_registry_number(), do: "NCC-#{Enum.random(1000..9999)}"
  def random_stardate(), do: (42_000 - 41_000) * :rand.uniform() + 41_000
  def format_stardate(stardate), do: :io_lib.format("~.1f", [stardate]) |> to_string()
end
