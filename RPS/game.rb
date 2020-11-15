# Move class used to compare different moves
# Indiviual moves have been made into individual classes, which allows
# for more customization of the rules, but requires a lot more code
class Move
  attr_reader :name

  def >(other_move)
    win_against?(other_move)
  end

  def <(other_move)
    (self.class != other_move.class) &&
      (other_move.win_against?(self))
  end

  def to_s
    name
  end
end

class Rock < Move
  def initialize
    @name = 'rock'
  end

  def win_against?(other_move)
    (other_move.name == 'scissors') ||
      (other_move.name == 'lizard')
  end
end

class Paper < Move
  def initialize
    @name = 'paper'
  end

  def win_against?(other_move)
    (other_move.name == 'rock') ||
      (other_move.name == 'spock')
  end
end

class Scissors < Move
  def initialize
    @name = 'scissors'
  end

  def win_against?(other_move)
    (other_move.name == 'paper') ||
      (other_move.name == 'lizard')
  end
end

class Lizard < Move
  def initialize
    @name = 'lizard'
  end

  def win_against?(other_move)
    (other_move.name == 'paper') ||
      (other_move.name == 'spock')
  end
end

class Spock < Move
  def initialize
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
  def set_name
    self.name = %w(R2D2 Hal Chappie C3PO).sample
  end

  # Computer Personalities

  def choose
    self.move = MOVE_HASH.values.sample.new
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

  def clear_screen
    # system("clear") # Linux/Mac
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
    return false if answer == 'n'
    return true if answer == 'y'
  end

  def play
    clear_screen
    display_welcome_message
    loop do
      loop do
        human.choose
        computer.choose
        clear_screen
        display_moves
        winner = calculate_winner
        display_winner_message(winner)
        display_score
        break if max_score?
      end
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
