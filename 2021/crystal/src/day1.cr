class AdventOfCode::Day1
  def a(depths)
    count = 0
    depths.each_with_index do |depth, index|
      next if index == 0
      count += 1 if depth > depths[index - 1]
    end
    count
  end

  def b(items)
    list = [] of UInt32
    items.each_with_index do |item, index|
      next if item == 0 || item == 1
      list << (items[index - 2] + items[index - 1] + item)
    end
    a(list)
  end
end
