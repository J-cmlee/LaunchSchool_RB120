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

  def initialize
    enter_name
  end

  def enter_name
    name = nil
    loop do
      puts "Please enter #{self.class} name: "
      name = gets.chomp
      break if !name.empty? && name =~ /[A-Za-z]/
      puts "Please enter in a valid name."
    end
    @name = name
  end
end

# inherits player values + includes offsense/defense
class Computer < Player
  # Will first store all the lines that have almost won
  # 1. Will try and win
  # 2. Will try and defend if not possible
  # 3. Will pick a random available square
  COMPUTER_MARKER = "&"

  def initialize
    @marker = COMPUTER_MARKER
    super
  end

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

class Human < Player
  def initialize
    super
    set_marker
  end

  def set_marker
    marker = nil
    loop do
      puts "Please enter a marker for the player (A-Z, 0-9): "
      marker = gets.chomp
      break if marker.length == 1 && marker =~ /[a-zA-Z0-9]/
      puts "Please enter a valid marker"
    end
    @marker = marker.upcase
  end
end

class Score
  WIN_SCORE = 1

  attr_accessor :human, :computer

  def initialize
    @human = 0
    @computer = 0
  end

  def reset
    self.human = 0
    self.computer = 0
  end

  def game_won_by
    return "Player" if @human == WIN_SCORE
    return "Computer" if @computer == WIN_SCORE
  end
end

class TTTGame
  attr_reader :board, :human, :computer, :score

  def initialize
    @board = Board.new
    @score = Score.new
  end

  def play
    clear
    display_welcome_message
    settings
    clear
    main_game
    display_goodbye_message
  end

  private

  def settings
    @human = Human.new
    @current_marker = human.marker
    @computer = Computer.new
  end

  def main_game
    loop do
      play_round
      break unless play_again?
      display_play_again_message
      score.reset
    end
  end

  def play_round
    loop do
      display_board
      player_move
      update_score
      display_result
      reset
      break if score.game_won_by
    end
    display_final_score
  end

  def display_final_score
    puts "Final score:"
    puts "#{human.name}: #{score.human}"
    puts "#{computer.name}: #{score.computer}"
  end

  def update_score
    case board.winning_marker
    when human.marker then score.human += 1
    when computer.marker then score.computer += 1
    end
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts "First to #{Score::WIN_SCORE} wins!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == human.marker
  end

  def display_board
    puts "#{human.name} (#{human.marker}): Score #{score.human}"
    puts "#{computer.name} (#{computer.marker}): Score #{score.computer}"
    puts ""
    board.draw
    puts ""
  end

  def joinor(array)
    values = array.clone.map(&:to_s)
    last_value = values.pop

    return last_value if values.empty?
    values[-1] += " or #{last_value}"
    values.join(", ")
  end

  def number?(obj)
    obj.to_s == obj.to_i.to_s
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp
      break if number?(square) && board.unmarked_keys.include?(square.to_i)
      puts "Sorry, that's not a valid choice."
    end

    board[square.to_i] = human.marker
  end

  def computer_moves
    board[computer.move_set(board)] = computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
    gets.chomp
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear
    system("clear")
    system("cls")
  end

  def reset
    board.reset
    @current_marker = human.marker
    clear
  end

  def display_play_again_message
    clear
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play
