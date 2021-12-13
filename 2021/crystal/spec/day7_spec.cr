require "./spec_helper"

Spectator.describe AdventOfCode::Day7 do
  subject {
<<-TEXT
16,1,2,0,4,2,7,1,2,14
TEXT
  }
  let(input) { AdventOfCode::Helpers.string_lines_to_a(subject) }

  describe "#a" do
    it "works" do
      expect(described_class.new.a(input)).to eq(37)
    end
  end

  describe "#b" do
    it "works" do
      expect(described_class.new.b(input)).to eq(168)
    end
  end
end
