defmodule HighSchoolSweetheart do
  import String

  def first_letter(name) do
    name
    |> trim
    |> first
  end

  def initial(name) do
    name
    |> first_letter
    |> capitalize
    |> Kernel.<>(".")
  end

  def initials(full_name) do
    [name, surname] = full_name |> split
    first = name |> initial
    second = surname |> initial

    "#{first} #{second}"
  end

  def pair(full_name1, full_name2) do
    """
    ❤-------------------❤
    |  #{full_name1 |> initials}  +  #{full_name2 |> initials}  |
    ❤-------------------❤
    """
  end
end
