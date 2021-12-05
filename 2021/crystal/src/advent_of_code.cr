module AdventOfCode
  module Helpers
    extend self

    def string_lines_to_a(str : String)
      str.each_line.to_a
    end
  end
end

require "./days/*"
