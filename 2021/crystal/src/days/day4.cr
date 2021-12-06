class AdventOfCode::Day4
  class Position
    property value : UInt32
    property marked : Bool = false

    def initialize(@value)
    end

    def unmarked
      !marked
    end

    def to_s(io)
      io << @value.to_s
    end
  end

  class Board
    MAX_BOARD_SIZE = 5

    property board = [] of Array(Position)

    def add_row(row : String) : Nil
      if @board.size + 1 > MAX_BOARD_SIZE
        raise "Too many rows!"
      end

      positions = row.split(" ").reject!(&.empty?).map do |pos_str|
        Position.new(pos_str.to_u32)
      end

      if positions.size > MAX_BOARD_SIZE
        raise "Too many columns!"
      end

      @board << positions
    end

    def mark_number(number) : Nil
      @board.each do |row|
        row.each do |pos|
          if pos.value == number
            pos.marked = true
          end
        end
      end
    end

    def won? : Bool
      # won by rows
      @board.each do |row|
        if row.all?(&.marked)
          return true
        end
      end

      # won by cols
      MAX_BOARD_SIZE.times do |outer|
        positions = [] of Position
        MAX_BOARD_SIZE.times do |inner|
          positions << @board[inner][outer]
        end
        if positions.all?(&.marked)
          return true
        end
      end

      false
    end

    def calculate(winning_number)
      @board.flatten.select(&.unmarked).sum(&.value) * winning_number
    end

    def to_s(io)
      io << "[\n"
      @board.each_with_index do |row, idx|
        io << "  ["
        io << row.map(&.value).join(" ")
        io << "]\n"
      end
      io << "]"
    end
  end

  def a(input : Array(String))
    numbers = parse_numbers(input)
    boards = parse_boards(input)

    winning_board : Board? = nil
    winning_number : UInt32? = nil

    numbers.each_with_index do |called_num, index|
      boards.each do |b|
        b.mark_number(called_num)
      end

      boards.each do |b|
        winning_board = b if b.won?
        winning_number = called_num
      end

      break unless winning_board.nil?
    end

    raise "No winners!" if winning_board.nil?

    board_won = winning_board.not_nil!
    number_won = winning_number.not_nil!

    board_won.calculate(number_won)
  end

  def b(input : Array(String))
    numbers = parse_numbers(input)
    boards = parse_boards(input)

    last_board_won : Board? = nil
    last_number_won : UInt32? = nil

    numbers.each_with_index do |called_num, index|
      boards.each do |b|
        b.mark_number(called_num)
      end

      boards_to_delete = [] of Board

      boards.each do |b|
        if b.won?
          boards_to_delete << b
        end
      end

      boards_to_delete.each do |b|
        if boards.size == 1
          last_board_won = b
          last_number_won = called_num
          break
        else
          boards.delete(b)
        end
      end

      break unless last_board_won.nil?
    end

    raise "No winners!" if last_board_won.nil?

    board = last_board_won.not_nil!
    number = last_number_won.not_nil!

    board.calculate(number)
  end

  private def parse_numbers(input : Array(String))
    input[0].split(",").map(&.to_u32)
  end

  private def parse_boards(input : Array(String))
    boards = [] of Board

    i = 2
    while i < input.size
      if input[i].empty?
        i += 1
        next
      end

      board = Board.new
      next_items_size = i + Board::MAX_BOARD_SIZE
      while i < next_items_size
        board.add_row(input[i])
        i += 1
      end
      boards << board
    end

    boards
  end
end
