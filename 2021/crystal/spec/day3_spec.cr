require "./spec_helper"

Spectator.describe AdventOfCode::Day3 do
  subject {
    <<-TEXT
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    TEXT
  }
  let(input) { AdventOfCode::Helpers.string_lines_to_a(subject) }

  describe "#a" do
    it "works" do
      expect(described_class.new.a(input)).to eq(198)
    end
  end

  describe "#b" do
    it "works" do
      expect(described_class.new.b(input)).to eq(230)
    end
  end
end
