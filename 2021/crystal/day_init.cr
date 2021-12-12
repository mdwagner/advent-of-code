require "option_parser"

OptionParser.parse do |parser|
  parser.on "-d DAY", "--day=DAY", "Which day" do |day_str|
    day = day_str.to_i
    File.write("#{__DIR__}/../_inputs/day#{day}.txt", "")
    File.write("#{__DIR__}/spec/day#{day}_spec.cr", <<-SPEC)
require "./spec_helper"

Spectator.describe AdventOfCode::Day#{day} do
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
end\n
SPEC
    File.write("#{__DIR__}/src/days/day#{day}.cr", <<-TEXT)
class AdventOfCode::Day#{day}
  def a(input : Array(String))
  end

  def b(input : Array(String))
  end
end\n
TEXT
    exit
  end
end
