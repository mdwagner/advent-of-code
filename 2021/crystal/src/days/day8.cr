class AdventOfCode::Day8
  def a(input : Array(String))
    #  a
    # b c
    #  d
    # e f
    #  g
    #
    # 0=6, 1=2, 2=5, 3=5, 4=4, 5=5, 6=6, 7=3, 8=7, 9=6
    # 1, 4, 7, 8 <-- only do these numbers first
    #
    # be      => cf      (1)
    # cfbegad => abcdefg (8)
    # cgeb    => bcdf    (4)
    # edb     => acf     (7)

    count = 0
    input.each do |line|
      _, output_values = line.split(" | ").map &.split(" ")

      output_values.each do |output_value|
        case output_value.size
        when 2, 3, 4, 7
          # Numbers: 1, 7, 4, 8
          count += 1
        #when 5
          # Numbers: 2, 3, 5
        #when 6
          # Numbers: 0, 6, 9
        end
      end
    end
    count
  end

  def b(input : Array(String))
    # acedgfb => abcdefg (8)
    # dab     => acf     (7)
    # eafb    => bcdf    (4)
    # ab      => cf      (1)

    # d => a
    # ? => b
    # ? => c
    # ? => d
    # ? => e
    # ? => f
    # ? => g
  end
end
