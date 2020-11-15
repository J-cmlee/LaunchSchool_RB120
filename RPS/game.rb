# Move class used to compare different moves
# Indiviual moves have been made into individual classes, which allows
# for more customization of the rules, but requires a lot more code
class Move
  attr_reader :name

  def initialize; end

  def >(other_move)
    win_against?(other_move)
  end

  def <(other_move)
    (other_move.win_against?(self))
  end

  def to_s
    name
  end
end

class Rock < Move
  def initialize
    super
    @name = 'rock'
  end

  def win_against?(other_move)
    (other_move.name == 'scissors') ||
      (other_move.name == 'lizard')
  end
end

class Paper < Move
  def initialize
    super
    @name = 'paper'
  end

  def win_against?(other_move)
    (other_move.name == 'rock') ||
      (other_move.name == 'spock')
  end
end

class Scissors < Move
  def initialize
    super
    @name = 'scissors'
  end

  def win_against?(other_move)
    (other_move.name == 'paper') ||
      (other_move.name == 'lizard')
  end
end

class Lizard < Move
  def initialize
    super
    @name = 'lizard'
  end

  def win_against?(other_move)
    (other_move.name == 'paper') ||
      (other_move.name == 'spock')
  end
end

class Spock < Move
  def initialize
    super
    @name = 'spock'
  end

  def win_against?(other_move)
    (other_move.name == 'scissors') ||
      (other_move.name == 'rock')
  end
end

# Constant hash to link string to Object names
MOVE_HASH = {
  'rock' => Rock,
  'paper' => Paper,
  'scissors' => Scissors,
  'lizard' => Lizard,
  'spock' => Spock
}

# Player class for storing moves and scores for user
class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end
end

# Human controller player class
class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?

      puts 'Sorry, must enter a value'
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose #{MOVE_HASH.keys}:"
      choice = gets.chomp.downcase
      break if MOVE_HASH.keys.include?(choice)

      puts 'Sorry, invalid choice'
    end
    self.move = MOVE_HASH[choice].new
  end
end

# Computer controlled player class
class Computer < Player
  attr_accessor :personality

  def set_name
    self.name = %w(R2D2 Hal C3PO).sample
    set_personality
  end

  def choose
    self.move = personality.sample.new
  end

  private

  # Computer Personalities
  # depending on the personality, the number of each move class is
  # adjusted in count within the @personality array
  def set_personality
    case name
    when 'R2D2'
      set_r2d2_personality
    when 'Hal'
      set_hal_personality
    when 'C3PO'
      self.personality = [Rock]
    end
  end

  def set_r2d2_personality
    self.personality = MOVE_HASH.values
  end

  def set_hal_personality
    p_array = []
    10.times { p_array << Rock }
    21.times { p_array << Scissors }
    42.times { p_array << Paper }
    self.personality = p_array
  end
end

# History class to store each round
class History
  SPACING = 18
  def initialize
    @record = []
    @round = 1
  end

  def add_record(player1, player2)
    @record << [@round, player1.move.name, player2.move.name,
                player1.score, player2.score]
    @record.last.map! { |unit| unit.to_s.ljust(SPACING) }
    @round += 1
  end

  def print_record(player1, player2)
    puts "MATCH HISTORY"
    header = ["Round", player1.name + " Move", player2.name + " Move",
              player1.name + " Score", player2.name + " Score"]
    header = header.map! { |unit| unit.ljust(SPACING) }.join
    puts header
    puts "=" * header.length
    @record.each { |round| puts round.join }
  end
end

# Game Orchestration Engine
class RPSGame
  WIN_SCORE = 10
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts '================================'
    puts 'Welcome to Rock, Paper, Scissors'
    puts '================================'
    puts "First to #{WIN_SCORE} wins!"
    puts ""
  end

  def display_goodbye_message
    puts 'Thanks for playing Rock, Paper, Scissors.'
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def calculate_winner
    if human.move > computer.move
      human.score += 1
      human
    elsif human.move < computer.move
      computer.score += 1
      computer
    end
  end

  def display_winner_message(winner)
    if winner == human
      puts "#{human.name} won"
    elsif winner == computer
      puts "#{computer.name} won"
    else
      puts "It's a tie"
    end
  end

  def max_score?
    (human.score == WIN_SCORE) || (computer.score == WIN_SCORE)
  end

  def display_score
    puts "Score:"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def reset_score
    human.score = 0
    computer.score = 0
  end

  def clear_screen
    system("clear") # Linux/Mac
    system("cls") # Windows
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again (y/n)'
      answer = gets.chomp
      break if %w(y n).include? answer.downcase

      puts 'Sorry, must be y or n'
    end
    return true if answer == 'y'
  end

  def play
    clear_screen
    display_welcome_message
    history = History.new
    loop do # Loop to play again until user quits
      loop do # Loop until one player reaches maximum score
        human.choose
        computer.choose
        clear_screen
        display_moves
        winner = calculate_winner
        display_winner_message(winner)
        history.add_record(human, computer)
        display_score
        break if max_score?
      end
      break unless play_again?
      reset_score
    end
    clear_screen
    display_goodbye_message
    history.print_record(human, computer)
  end
end

RPSGame.new.play
