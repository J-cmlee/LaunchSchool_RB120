# For practice and testing

class Vehicle

  @@number_of_vehicles = 0

  def self.number_of_vehicles
    puts "There are #{@@number_of_vehicles} vehicles"
  end

  def self.gas(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end
end

class MyCar < Vehicle
  attr_accessor :color, :model
  attr_reader :year

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def speed_up(accel)
    @speed += accel
  end

  def break(decel)
    @speed -= decel
  end

  def shutdown
    @speed = 0
  end

  def spray_paint(color)
    self.color = color
    puts "#{@color}"
  end
end

car1 = MyCar.new(2000, "red", "model Y")
car1.spray_paint("blue")