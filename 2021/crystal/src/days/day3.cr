require "bit_array"

class AdventOfCode::Day3
  enum Mode
    Min
    Max
  end

  def a(input : Array(String))
    return 0 if input.size < 1

    max_len = input[0].size
    gammas = BitArray.new(max_len)

    index : UInt32 = 0
    while index < max_len
      zeros = [] of String
      ones = [] of String

      input.each do |str|
        case str.char_at(index).to_i(2)
        when 0
          zeros << str
        when 1
          ones << str
        end
      end

      gammas[index] = !(zeros.size > ones.size)

      index += 1
    end

    epsilons = gammas.dup
    epsilons.invert

    gamma = bit_array_to_i(gammas)
    epsilon = bit_array_to_i(epsilons)

    gamma * epsilon
  end

  def b(input : Array(String))
    max_len = input[0].size

    oxygen_gens = input.dup
    co2_scrubbers = input.dup

    index : UInt32 = 0

    # calculate oxygen generator rating
    while index < max_len
      break if oxygen_gens.size == 1

      oxygen_gens = rating_helper(oxygen_gens, index, :max)

      index += 1
    end

    index = 0

    # calculate co2 scrubber rating
    while index < max_len
      break if co2_scrubbers.size == 1

      co2_scrubbers = rating_helper(co2_scrubbers, index, :min)

      index += 1
    end

    x = oxygen_gens[0].to_i(2)
    y = co2_scrubbers[0].to_i(2)

    x * y
  end

  private def rating_helper(list : Array(String), index, mode : Mode) : Array(String)
    zeros = [] of String
    ones = [] of String

    list.each do |str|
      case str.char_at(index).to_i(2)
      when 0
        zeros << str
      when 1
        ones << str
      end
    end

    case mode
    in .max?
      if zeros.size > ones.size
        zeros
      else
        ones
      end
    in .min?
      if ones.size < zeros.size
        ones
      else
        zeros
      end
    end
  end

  private def bit_array_to_i(ba : BitArray)
    ba.map { |v| v ? 1 : 0 }.join.to_i(2)
  end
end
