class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
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
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
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
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
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

class Score
  WIN_SCORE = 5

  attr_accessor :human, :computer

  def initialize
    @human = 0
    @computer = 0
  end

  def to_s
    "Human: #{@human} Computer: #{@computer}"
  end

  def reset
    self.human = 0
    self.computer = 0
  end

  def game_won?
    return "Player" if @human == WIN_SCORE
    return "Computer" if @computer == WIN_SCORE
  end
end

class TTTGame
  COMPUTER_MARKER = "&"

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
    human_name = get_name("Player")
    human_marker = set_marker
    @human = Player.new(human_marker, human_name)
    @current_marker = human.marker

    computer_name = get_name("Computer")
    @computer = Player.new(COMPUTER_MARKER, computer_name)
  end

  def get_name(player_type)
    name = nil
    loop do
      puts "Please enter #{player_type} name: "
      name = gets.chomp
      break unless name.empty?
      puts "Please enter in a valid name."
    end
    name
  end

  def set_marker
    marker = nil
    loop do
      puts "Please enter a marker for the player (A-Z, 0-9): "
      marker = gets.chomp
      break if marker.length == 1 && marker =~ /[a-zA-Z0-9]/
      puts "Please enter a valid marker"
    end
    marker.upcase
  end

  def main_game
    loop do
      play_round
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def play_round
    display_board
    player_move
    display_result
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
    puts "#{human.name}: #{human.marker} | #{computer.name}: #{computer.marker}"
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

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
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
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play
