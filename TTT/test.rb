class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def [](num)
    @squares[num].marker
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if identical_markers?(squares, 3)
        return squares.first.marker
      end
    end
    nil
  end

  def almost_won_lines
    lines = []
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if identical_markers?(squares, 2)
        lines << line unless line.select { |i| @squares[i].marker == ' ' }.empty?
      end
    end
    return lines unless lines.empty?
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def identical_markers?(squares, count)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != count
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker
  attr_accessor :name

  def initialize(marker, name)
    @marker = marker
    @name = name
  end
end

# inherits player values + includes offsense/defense
class Computer < Player
  # Will first store all the lines that have almost won
  # 1. Will try and win
  # 2. Will try and defend if not possible
  # 3. Will pick a random available square
  def move_set(board)
    danger_lines = board.almost_won_lines
    return board.unmarked_keys.sample if danger_lines.nil?
    danger_lines.each do |line|
      if line.map { |index| board[index] }.include?(marker)
        return line.select { |index| board[index] == ' ' }.first
      end
    end
    danger_lines.first.select { |index| board[index] == ' ' }.first
  end
end

board = Board.new
computer = Computer.new('O', 'compy')
board[1] = 'X'
board[2] = ' '
board[3] = ' '
board[5] = 'X'
board[7] = ' '
board[8] = 'O'
board[9] = ' '

p board.almost_won_lines
p computer.move_set(board)
