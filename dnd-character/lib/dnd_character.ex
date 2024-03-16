defmodule DndCharacter do
  @type t :: %__MODULE__{
          strength: pos_integer(),
          dexterity: pos_integer(),
          constitution: pos_integer(),
          intelligence: pos_integer(),
          wisdom: pos_integer(),
          charisma: pos_integer(),
          hitpoints: pos_integer()
        }

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  @spec modifier(pos_integer()) :: integer()
  def modifier(constitution), do: Integer.floor_div(constitution - 10, 2)

  @spec ability :: pos_integer()
  def ability do
    1..6
    |> Enum.take_random(4)
    |> Enum.reduce({0, 6}, fn x, {sum, min} -> {sum + x, if(x < min, do: x, else: min)} end)
    |> then(fn {sum, min} -> sum - min end)
  end

  @spec character :: t()
  def character do
    character = %DndCharacter{
      strength: ability(),
      dexterity: ability(),
      constitution: ability(),
      intelligence: ability(),
      wisdom: ability(),
      charisma: ability()
    }

    %DndCharacter{character | hitpoints: 10 + modifier(character.constitution)}
  end
end
