require "./spec_helper"

Spectator.describe AdventOfCode::Day6 do
  subject {
<<-TEXT
3,4,3,1,2
TEXT
  }
  let(input) { AdventOfCode::Helpers.string_lines_to_a(subject) }

  describe "#a" do
    it "works" do
      expect(described_class.new.a(input)).to eq(5934)
    end
  end

  describe "#b" do
    it "works" do
      expect(described_class.new.b(input)).to eq(26_984_457_539)
    end
  end
end
