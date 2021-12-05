require "./spec_helper"

Spectator.describe AdventOfCode::Day1 do
  subject {
    <<-TEXT
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    TEXT
  }
  let(input) { AdventOfCode::Helpers.string_lines_to_a(subject) }

  describe "#a" do
    it "works" do
      expect(described_class.new.a(input)).to eq(7)
    end
  end

  describe "#b" do
    it "works" do
      expect(described_class.new.b(input)).to eq(5)
    end
  end
end
