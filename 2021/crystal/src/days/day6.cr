class AdventOfCode::Day6
  def a(input : Array(String), days = 80)
    fish_h = Hash(Int32, UInt64).new
    9.times do |n|
      fish_h[n] = 0
    end
    input[0].split(",").each do |n|
      fish_h[n.to_i] += 1
    end

    days.times do
      fishes_to_add = 0

      if fish_h[0] > 0
        fishes_to_add = fish_h[0]
        fish_h[0] = 0 # should always reset fish 0
      end

      (1..8).to_a.each do |num|
        fish_h[num - 1] = fish_h[num]
        fish_h[num] = 0
      end

      fish_h[8] += fishes_to_add # adds new fishes
      fish_h[6] += fishes_to_add # reset existing fishes
    end

    fish_h.values.sum
  end

  private def print_fishes(hash)
    hash.each do |k, v|
      v.times { print("#{k},") }
    end
    print("\n")
  end

  def b(input : Array(String))
    a(input, 256)
  end
end
