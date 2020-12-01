# frozen_string_literal: true

class GuessingGame
  attr_accessor :guesses

  def initialize
    @guesses = 7
    @secret = (1..100).to_a.sample
  end

  def play
    7.times do
      break if user_guess == true
    end
    if guesses == 0
      puts 'You have no more guesses.  You lost!'
    else
      puts "That's the number!"
      puts ''
      puts 'You won!'
    end
  end

  def reset

  end

  private

  attr_reader :secret

  def user_guess
    puts "You have #{guesses} remaining."
    puts 'Enter a number between 1 and 100: '
    guess = gets.chomp.to_i
    return true if guess == secret

    puts 'Your guess is too low.' if guess < secret
    puts 'Your guess is too high.' if guess > secret
    puts ''
    self.guesses -= 1
  end
end

game = GuessingGame.new
game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 104
# Invalid guess. Enter a number between 1 and 100: 50
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 75
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 85
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 0
# Invalid guess. Enter a number between 1 and 100: 80

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 81
# That's the number!

# You won!

# game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 50
# Your guess is too high.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 25
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 37
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 31
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 34
# Your guess is too high.

# You have 2 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have 1 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have no more guesses. You lost!
