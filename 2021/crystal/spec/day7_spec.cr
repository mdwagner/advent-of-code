require "./spec_helper"

Spectator.describe AdventOfCode::Day7 do
  subject {
<<-TEXT
TEXT
  }
  let(input) { AdventOfCode::Helpers.string_lines_to_a(subject) }

  describe "#a" do
    it "works" do
      expect(described_class.new.a(input)).to eq(0)
    end
  end

  describe "#b" do
    it "works" do
      expect(described_class.new.b(input)).to eq(0)
    end
  end
end
