defmodule AOC.Day08.Part1 do
  defp parse_digits(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" | ")
      |> List.last
      |> String.split(" ")
    end)
  end

  defp group_by_digits(input) do
    input
    |> Enum.map(fn entry ->
      entry |> Enum.group_by(&String.length/1)
    end)
  end

  defp count_1478(input) do
    counts = input
      |> Enum.reduce(%{1 => 0, 4 => 0, 7 => 0, 8 => 0}, fn digit, %{1 => one, 4 => four, 7 => seven, 8 => eight} ->
        uone = if digit[2] != nil do length(digit[2]) else 0 end
        ufour = if digit[4] != nil do length(digit[4]) else 0 end
        useven = if digit[3] != nil do length(digit[3]) else 0 end
        ueight = if digit[7] != nil do length(digit[7]) else 0 end

        %{1 => one + uone, 4 => four + ufour, 7 => seven + useven, 8 => eight + ueight}
      end)

    counts[1] + counts[4] + counts[7] + counts[8]
  end

  def run() do
    File.read!("input.txt")
    |> parse_digits
    |> group_by_digits
    |> count_1478
  end
end

defmodule AOC.Day08.Part2 do
  defp parse_digits(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [patterns, digits] = line |> String.split(" | ")

      %{
        patterns: patterns |> String.split(" ") |> Enum.group_by(&String.length/1),
        digits: digits |> String.split(" "),
      }
    end)
  end

  defp find_pattern(input) do
    input
    |> Enum.map(&find_pattern_for_line/1)
    |> Enum.sum()
  end

  defp find_pattern_for_line(line) do
    patterns = Map.get(line, :patterns)
    if patterns == nil do
      IO.inspect("nil patterns")
    end

    ones = patterns[2] |> Enum.at(0) |> String.split("", trim: true)
    fours = patterns[4] |> Enum.at(0) |> String.split("", trim: true)
    sevens = patterns[3] |> Enum.at(0) |> String.split("", trim: true)

    #  aaaa
    # b    c
    # b    c
    #  dddd
    # e    f
    # e    f
    #  gggg

    # Find "a"
    a = if ones != nil and sevens != nil do
      sevens -- ones |> Enum.at(0)
    end

    # Find "b" and "d"
    b_and_d = if ones != nil and fours != nil do
      fours -- ones
    end

    # Find "b"
    fives = patterns[5]
    b = if fives != nil do
      [possible_b, possible_d] = b_and_d

      only_b = fives
        |> Enum.filter(fn item ->
          item |> String.split("") |> Enum.find(fn item -> item == possible_b end)
        end)

      if length(only_b) == 1 do
        possible_b
      else
        possible_d
      end
    end

    # Find "d"
    d = b_and_d -- [b] |> Enum.at(0)

    # Find "c" and "f"
    c_and_f = if ones != nil and sevens != nil do
      sevens -- [a]
    end

    # Find "f"
    f = if fives != nil do
      [possible_c, possible_f] = c_and_f

      # Digit number 5
      has_b = fives
        |> Enum.find(fn item ->
          item |> String.contains?(b)
        end)

      if has_b != nil do
        if String.contains?(has_b, possible_c) do
          possible_c
        else
          possible_f
        end
      end

      # Digit number 2
      has_c = fives
        |> Enum.find(fn item ->
          contains_b = item |> String.contains?(b)
          contains_possible_c = item |> String.contains?(possible_c)
          contains_possible_f = item |> String.contains?(possible_f)
          contains_either_possible = (contains_possible_c && !contains_possible_f) || (!contains_possible_c && contains_possible_f)

          contains_b && contains_either_possible
        end)

      if has_c != nil do
        if String.contains?(has_c, possible_c) do
          possible_c
        else
          possible_f
        end
      end
    end

    # Find "c"
    c = c_and_f -- [f] |> Enum.at(0)

    # Find "g"
    nines = patterns[7]
    g = if nines != nil || fives != nil do
      all_known = [a, b, c, d, f]

      if nines != nil do
        nines
          |> Enum.map(fn item ->
            arr_item = item |> String.split("", trim: true)
            arr_item -- all_known |> Enum.join("")
          end)
          |> Enum.find(fn item -> String.length(item) == 1 end)
      end

      if fives != nil do
        number_three = fives
          |> Enum.find(fn item ->
            item |> String.contains?(c) && item |> String.contains?(f)
          end)

        if number_three != nil do
          arr_three = number_three |> String.split("", trim: true)
          arr_three -- all_known |> Enum.join("")
        end
      end
    end

    # Find "e"
    e = ["a", "b", "c", "d", "e", "f", "g"] -- [a, b, c, d, f, g] |> Enum.at(0)

    # Mapping
    m_zero = [a, b, c, e, f, g]
    m_one = [c, f]
    m_two = [a, c, d, e, g]
    m_three = [a, c, d, f, g]
    m_four = [b, c, d, f]
    m_five = [a, b, d, f, g]
    m_six = [a, b, d, e, f, g]
    m_seven = [a, c, f]
    m_eight = [a, b, c, d, e, f, g]
    m_nine = [a, b, c, d, f, g]

    digits = Map.get(line, :digits)
    if digits == nil do
      IO.inspect("nil digits")
    end

    total = digits
      |> Enum.map(fn digit ->
        split_digit = digit |> String.split("", trim: true)

        cond do
          length(split_digit) == length(m_zero) && length(split_digit -- m_zero) == 0 ->
            0
          length(split_digit) == length(m_one) && length(split_digit -- m_one) == 0 ->
            1
          length(split_digit) == length(m_two) && length(split_digit -- m_two) == 0 ->
            2
          length(split_digit) == length(m_three) && length(split_digit -- m_three) == 0 ->
            3
          length(split_digit) == length(m_four) && length(split_digit -- m_four) == 0 ->
            4
          length(split_digit) == length(m_five) && length(split_digit -- m_five) == 0 ->
            5
          length(split_digit) == length(m_six) && length(split_digit -- m_six) == 0 ->
            6
          length(split_digit) == length(m_seven) && length(split_digit -- m_seven) == 0 ->
            7
          length(split_digit) == length(m_eight) && length(split_digit -- m_eight) == 0 ->
            8
          length(split_digit) == length(m_nine) && length(split_digit -- m_nine) == 0 ->
            9
          true ->
            -1
        end
      end)
      |> Enum.join("")
      |> String.to_integer

    total
  end

  def run() do
    File.read!("input.txt")
    |> parse_digits
    |> find_pattern
  end
end

IO.inspect("Part 1: #{AOC.Day08.Part1.run()}")
IO.inspect("Part 2: #{AOC.Day08.Part2.run()}")
