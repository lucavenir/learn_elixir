defmodule PaintByNumber do
  import Bitwise

  # recursive workaround to compute ** 0.5
  def palette_bit_size(n) when (n &&& n - 1) == 0, do: compute_bit_size(n >>> 1)
  def palette_bit_size(n), do: 1 + compute_bit_size(n >>> 1)

  defp compute_bit_size(1), do: 1
  defp compute_bit_size(color_count), do: 1 + compute_bit_size(color_count >>> 1)

  def empty_picture(), do: <<>>

  def test_picture(), do: <<0::2, 1::2, 2::2, 3::2>>

  def prepend_pixel(picture, color_count, pixel_color_index) do
    bit_size = palette_bit_size(color_count)
    <<pixel_color_index::size(bit_size), picture::bitstring>>
  end

  def get_first_pixel(<<>>, _), do: nil

  def get_first_pixel(picture, color_count) do
    bit_size = palette_bit_size(color_count)
    <<first::size(bit_size), _::bitstring>> = picture
    first
  end

  def drop_first_pixel(<<>>, _), do: <<>>

  def drop_first_pixel(picture, color_count) do
    bit_size = palette_bit_size(color_count)
    <<_::size(bit_size), rest::bitstring>> = picture
    rest
  end

  def concat_pictures(picture1, picture2), do: <<picture1::bitstring, picture2::bitstring>>
end
