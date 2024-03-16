defmodule LanguageList do
  def new(), do: []
  def add(list, language), do: [language | list]
  def remove([_ | others]), do: others
  def first([head | _]), do: head
  def count([]), do: 0
  def count([_ | others]), do: count(others) + 1
  def functional_list?([]), do: false
  def functional_list?(["Elixir" | _]), do: true
  def functional_list?([_ | others]), do: functional_list?(others)
end
