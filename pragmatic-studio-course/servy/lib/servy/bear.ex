defmodule Servy.Bear do
  defstruct id: nil, name: "", type: "", hibernating: false

  def is_grizzly(%Servy.Bear{} = bear) do
    bear.type == "Grizzly"
  end

  def sort_by_name(%Servy.Bear{} = b1, %Servy.Bear{} = b2) do
    b1.name <= b2.name
  end
end
