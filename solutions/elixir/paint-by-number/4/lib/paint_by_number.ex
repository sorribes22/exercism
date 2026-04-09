defmodule PaintByNumber do
  defp bit_range_by_number(number, bit_range \\ 1)
  defp bit_range_by_number(number, bit_range) when number <= Bitwise.bsl(1, bit_range), do: bit_range
  defp bit_range_by_number(number, bit_range), do: bit_range_by_number(number, bit_range + 1)

  def palette_bit_size(color_count), do: bit_range_by_number(color_count)

  def empty_picture, do: <<>>

  def test_picture(), do: <<0::2, 1::2, 2::2, 3::2>>

  def prepend_pixel(picture, color_count, pixel_color_index) do
    bit_range = palette_bit_size(color_count)

    <<pixel_color_index::size(bit_range), picture::bitstring>>
  end

  def get_first_pixel(<<>>, _color_count), do: nil
  def get_first_pixel(picture, color_count) do
    bit_range = palette_bit_size(color_count)

    <<value::size(bit_range), _rest::bitstring>> = picture

    value
  end

  def drop_first_pixel(<<>>, _color_count), do: <<>>
  def drop_first_pixel(picture, color_count) do
    bit_range = palette_bit_size(color_count)

    <<_value::size(bit_range), rest::bitstring>> = picture

    rest
  end

  def concat_pictures(picture1, picture2), do: <<picture1::bitstring, picture2::bitstring>>
end
