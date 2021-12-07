class Part1
    @input : Array(Int32)

    def initialize(input)
        @input = input
    end

    def fuel_for_position(current, desired)
        (current - desired).abs
    end

    def total_fuel()
        smallest = 1000000000
        Range.new(0, 10000).each do |n|
            calculated = @input.map { |i| self.fuel_for_position(i, n) }.sum
            smallest = calculated if calculated < smallest
        end
        smallest
    end
end

class Part2
    @input : Array(Int32)

    def initialize(input)
        @input = input
    end

    def fuel_for_position(current, desired)
        d = (current - desired).abs
        d * (d + 1) / 2
    end

    def total_fuel()
        smallest = 1000000000
        Range.new(0, 10000).each do |n|
            calculated = @input.map { |i| self.fuel_for_position(i, n) }.sum
            smallest = calculated if calculated < smallest
        end
        smallest
    end
end

raw_input = File.open("input.txt") do |file|
    file.gets_to_end
end
input = raw_input.split(",").map { |i| i.to_i }  

part1 = Part1.new(input)
puts "Part 1 = #{part1.total_fuel}"

part2 = Part2.new(input)
puts "Part 2 = #{part2.total_fuel.to_i}"
