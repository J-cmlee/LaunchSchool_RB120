class Student

  attr_accessor :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other)
    self.grade > other.grade
  end

  protected
  def grade
    @grade
  end
end

joe = Student.new("joe", 50)
bob = Student.new("bob", 30)
puts "Well done!" if joe.better_grade_than?(bob)