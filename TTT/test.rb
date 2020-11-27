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
    return "human" if @human == WIN_SCORE
    return "computer" if @computer == WIN_SCORE
  end

end

score = Score.new
score.human += 1
puts score
p score.game_won?