require "./spec_helper"

Spectator.describe AdventOfCode::Day2 do
  subject {
    <<-TEXT
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    TEXT
  }
  let(input) { AdventOfCode::Helpers.string_lines_to_a(subject) }

  describe "#a" do
    it "part 1 works" do
      expect(described_class.new.a(input)).to eq(150)
    end

    it "part 2 works" do
      expect(described_class.new.a(input, true)).to eq(900)
    end
  end
end
