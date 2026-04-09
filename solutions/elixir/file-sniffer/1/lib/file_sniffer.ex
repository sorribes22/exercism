defmodule FileSniffer do
  def type_from_extension(extension) do
    case extension do
      "exe" -> "application/octet-stream"
      "bmp" -> "image/bmp"
      "png" -> "image/png"
      "jpg" -> "image/jpg"
      "gif" -> "image/gif"
      _ -> nil
    end
  end

  def type_from_binary(file_binary) do
    extension = case file_binary do
      <<0x7F, 0x45, 0x4C, 0x46, _::binary>> -> "exe"
      <<0x42, 0x4D, _::binary>> -> "bmp"
      <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>> -> "png"
      <<0xFF, 0xD8, 0xFF, _::binary>> -> "jpg"
      <<0x47, 0x49, 0x46, _::binary>> -> "gif"
      _ -> nil
    end

    extension |> type_from_extension()
  end

  def verify(file_binary, extension) do
    file_type = type_from_binary(file_binary)
    expected_file_type = type_from_extension(extension)

    if !!file_type and file_type == expected_file_type do
      {:ok, file_type}
    else
      {:error, "Warning, file format and file extension do not match."}
    end
  end
end
