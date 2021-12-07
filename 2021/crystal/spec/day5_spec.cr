require "./spec_helper"

Spectator.describe AdventOfCode::Day5 do
  subject {
<<-TEXT
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
TEXT
  }
  let(input) { AdventOfCode::Helpers.string_lines_to_a(subject) }

  describe "#a" do
    it "works" do
      expect(described_class.new.a(input)).to eq(5)
    end
  end

  describe "#b" do
    it "works" do
      expect(described_class.new.b(input)).to eq(12)
    end
  end
end
