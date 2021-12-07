class AdventOfCode::Day5
  def a(input : Array(String))
    # [{ {x1,y1}, {x2,y2} }, ...]
    vents = parse_vents(input)

    max_x = vents.each.map { |lsp| [lsp[0][0], lsp[1][0]].max }.max + 1
    max_y = vents.each.map { |lsp| [lsp[0][1], lsp[1][1]].max }.max + 1

    diagram = Array(UInt32).new(max_x * max_y, 0)

    vents.each do |lsp|
      start_ls, end_ls = lsp

      x_match = start_ls[0] == end_ls[0]
      y_match = start_ls[1] == end_ls[1]

      if x_match
        # fill in y coords
        x = start_ls[0]
        coords_pair = [start_ls[1], end_ls[1]]

        ((coords_pair.min)..(coords_pair.max)).each do |y|
          diagram[coordinate_to_index(x, y, max_y)] += 1
        end
      elsif y_match
        # fill in x coords
        y = start_ls[1]
        coords_pair = [start_ls[0], end_ls[0]]

        ((coords_pair.min)..(coords_pair.max)).each do |x|
          diagram[coordinate_to_index(x, y, max_y)] += 1
        end
      end
    end

    diagram.select { |i| i >= 2 }.size
  end

  private def coordinate_to_index(x, y, max_y)
    x + (max_y * y)
  end

  def b(input : Array(String))
  end

  alias LineSegment = Tuple(UInt32, UInt32)
  alias LineSegmentPair = Tuple(LineSegment, LineSegment)

  private def parse_vents(input)
    input.map do |line|
      x, y = line.split(" -> ")
      x1, y1 = x.split(",")
      x2, y2 = y.split(",")

      start_segment = LineSegment.new(x1.to_u32, y1.to_u32)
      end_segment = LineSegment.new(x2.to_u32, y2.to_u32)
      LineSegmentPair.new(start_segment, end_segment)
    end
  end

  private def print_diagram(diagram, max_x)
    diagram.each_with_index do |value, index|
      if value == 0
        print "."
      else
        print value
      end

      if ((index + 1) % max_x) == 0
        print "\n"
      end
    end
  end
end
