module AdventOfCode
  module Helpers
    extend self

    def string_lines_to_a(str : String)
      str.each_line.to_a
    end
  end
end

require "./day1"
require "./day2"
require "./day3"

class AdventOfCode::Main
  def run!
    days = [] of String

    {% for day in 1..3 %}
    {% contents = read_file("#{__DIR__}/../inputs/day#{day}.txt") %}
    days << {{ contents.id.stringify }}
    {% end %}

    day1_input = AdventOfCode::Helpers.string_lines_to_a(days[0]).map(&.to_u32)
    day2_input = AdventOfCode::Helpers.string_lines_to_a(days[1])
    day3_input = AdventOfCode::Helpers.string_lines_to_a(days[2])

    day1_instance = AdventOfCode::Day1.new
    day1_a_result = day1_instance.a(day1_input)
    day1_b_result = day1_instance.b(day1_input)
    puts "Day 1a: #{day1_a_result}"
    puts "Day 1b: #{day1_b_result}"

    day2_instance = AdventOfCode::Day2.new
    day2_a_result = day2_instance.a(day2_input)
    day2_b_result = day2_instance.a(day2_input, true)
    puts "Day 2a: #{day2_a_result}"
    puts "Day 2b: #{day2_b_result}"


    day3_instance = AdventOfCode::Day3.new
    day3_a_result = day3_instance.a(day3_input)
    day3_b_result = day3_instance.b(day3_input)
    puts "Day 3a: #{day3_a_result}"
    puts "Day 3b: #{day3_b_result}"
  end
end
