class AdventOfCode::Day6
  def a(input : Array(String), days = 80)
    fishes = StaticArray(UInt64, 9).new(0)

    input[0].split(",").each do |n|
      fishes[n.to_i] += 1
    end

    days.times do
      fishes_to_add = 0

      fishes.each_with_index do |count, num|
        case num
        when 0
          if count > 0
            fishes_to_add = count
          end
        else
          fishes[num - 1] = count
        end
        fishes[num] = 0
      end

      fishes[8] += fishes_to_add # adds new fishes
      fishes[6] += fishes_to_add # reset existing fishes
    end

    fishes.sum
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
