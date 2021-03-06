class AdventOfCode::Day2
  def a(input, should_aim = false)
    horizontal : UInt32 = 0
    depth : UInt32 = 0
    aim : UInt32 = 0
    pairs = [] of String

    input.each do |line|
      command, num = line.split(" ")
      number = num.to_u32

      case command
      when "forward"
        horizontal += number
        depth += (aim * number) if should_aim
      when "down"
        should_aim ? (aim += number) : (depth += number)
      when "up"
        should_aim ? (aim -= number) : (depth -= number)
      end
    end

    horizontal * depth
  end

  def b(input)
    a(input, true)
  end
end
