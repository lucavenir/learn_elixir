defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet', or an error if 'planet' is not a planet.
  """
  @spec age_on(planet, pos_integer) :: {:ok, float} | {:error, String.t()}
  def age_on(planet, seconds), do: seconds |> seconds_to_years() |> orbital_computation(planet)

  defp orbital_computation(years, :mercury), do: {:ok, years / 0.2408467}
  defp orbital_computation(years, :venus), do: {:ok, years / 0.61519726}
  defp orbital_computation(years, :earth), do: {:ok, years / 1.0}
  defp orbital_computation(years, :mars), do: {:ok, years / 1.8808158}
  defp orbital_computation(years, :jupiter), do: {:ok, years / 11.862615}
  defp orbital_computation(years, :saturn), do: {:ok, years / 29.447498}
  defp orbital_computation(years, :uranus), do: {:ok, years / 84.016846}
  defp orbital_computation(years, :neptune), do: {:ok, years / 164.79132}
  defp orbital_computation(_, _), do: {:error, "not a planet"}

  defp seconds_to_years(seconds), do: seconds / (365.25 * 24 * 60 * 60)
end
