class MyCar
  attr_reader :year
  attr_accessor :color

  
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  # Class Methods
  def self.gas_mileage(litres, km)
    puts "#{km/litres} km/L of gas"
  end

  def to_s
    "This car is a #{color}, #{year}, #{@model}"
  end

  # Object Methods
  def speed_up(value)
    @speed += value
    puts "The speed is increased to #{@speed}"
  end

  def brake(value)
    @speed -= value
    puts "The speed is decreased to #{@speed}"
  end

  def speed
    puts "The current speed is #{@speed}"
  end

  def shut_down
    @speed = 0
    puts "The car is stopped"
  end

  def spray_paint(new_color)
    color = new_color
    puts "The car color has been changed to #{color}"
  end
end

lumina = MyCar.new(1997, 'chevy lumina', 'white')
lumina.speed_up(20)
lumina.speed
lumina.speed_up(20)
lumina.speed
lumina.brake(20)
lumina.speed
lumina.brake(20)
lumina.speed
lumina.shut_down
lumina.speed
lumina.color = 'black'
puts lumina.color
puts lumina.year
lumina.spray_paint('red')
MyCar.gas_mileage(13, 351)  # => "27 miles per gallon of gas"
my_car = MyCar.new("2010", "Ford Focus", "silver")
puts my_car