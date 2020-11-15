class Move
  attr_reader :name

  # Choices
  def >(other_move)
    p [self, other_move]
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
    (other_move.class == Scissors) ||
      (other_move.class == Lizard)
  end
end
class Paper
end
class Scissors
end
class Lizard
end
class Spock
end

rock = Rock.new
scissors = Scissors.new
p rock > scissors
array1 = [[1,2,3],[2,3,4]]

array1.each {|row| puts row.join(" ")}