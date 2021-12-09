require "./advent_of_code"

{% begin %}
{% day_count = system("ls -1 #{__DIR__}/../../_inputs/ | wc -l").to_i %}
{% for day in 1..day_count %}
{% contents = read_file("#{__DIR__}/../../_inputs/day#{day}.txt") %}

day{{day.id}}_input = AdventOfCode::Helpers.string_lines_to_a({{contents.id.stringify}})
day{{day.id}}_instance = AdventOfCode::Day{{day.id}}.new
day{{day.id}}_a_result = day{{day.id}}_instance.a(day{{day.id}}_input)
day{{day.id}}_b_result = day{{day.id}}_instance.b(day{{day.id}}_input)
puts "Day {{day.id}}a: #{day{{day.id}}_a_result}"
puts "Day {{day.id}}b: #{day{{day.id}}_b_result}"
puts

{% end %}
{% end %}
