class AdventOfCode::Day7
  def a(input : Array(String), part_2 = false)
    crabs = input.first.split(",").map(&.to_u32)

    min = crabs.min
    max = crabs.max

    cheapest_fuel = UInt32::MAX

    (min..max).each do |pos|
      fuel_outcome = crabs.sum do |c|
        n = (c.to_i - pos.to_i).abs
        if part_2
          0.5 * n * (n + 1)
        else
          n
        end
      end.to_i

      if fuel_outcome < cheapest_fuel
        cheapest_fuel = fuel_outcome
      end
    end

    cheapest_fuel
  end

  def b(input : Array(String))
    a(input, true)
  end
end
