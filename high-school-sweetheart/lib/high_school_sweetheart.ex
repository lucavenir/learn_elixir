defmodule HighSchoolSweetheart do
  def first_letter(name), do: name |> String.trim() |> trimmed_first_letter()
  defp trimmed_first_letter(<<a::utf8>> <> _), do: <<a::utf8>>

  def initial(name), do: name |> first_letter() |> String.upcase() |> Kernel.<>(".")

  def initials(full_name) do
    full_name |> String.trim() |> String.split(" ") |> dotted_initials()
  end

  defp dotted_initials([first_name, last_name]) do
    initial(first_name) <> " " <> initial(last_name)
  end

  def pair(full_name1, full_name2) do
    i1 = full_name1 |> initials()
    i2 = full_name2 |> initials()

    """
         ******       ******
       **      **   **      **
     **         ** **         **
    **            *            **
    **                         **
    **     #{i1}  +  #{i2}     **
     **                       **
       **                   **
         **               **
           **           **
             **       **
               **   **
                 ***
                  *
    """
  end
end
