def part1(input)
    h = 0
    d = 0

    input.each do |command|
        case command.split(" ")
        in "forward", amount
            h += amount.to_i
        in "down", amount
            d += amount.to_i
        in "up", amount
            d -= amount.to_i
        else
            raise "Invalid command" 
        end
    end

    puts("Horizontal=#{h}")
    puts("Depth=#{d}")
    puts("H*D=#{h * d}")
end

def part2(input)
    h = 0
    d = 0
    a = 0

    input.each do |command|
        case command.split(" ")
        in "forward", amount
            h += amount.to_i
            d += a * amount.to_i
        in "down", amount
            a += amount.to_i
        in "up", amount
            a -= amount.to_i
        else
            raise "Invalid command" 
        end
    end

    puts("Horizontal=#{h}")
    puts("Depth=#{d}")
    puts("Aim=#{a}")
    puts("H*D=#{h * d}")
end

puts("Part 1 ===")
part1(IO.readlines("input.txt", chomp: true))
puts("Part 2 ===")
part2(IO.readlines("input.txt", chomp: true))
