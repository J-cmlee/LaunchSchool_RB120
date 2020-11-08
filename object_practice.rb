module Towable
  def can_tow?(pounds)
    pounds < 2000 ? true : false
  end
end

class Vehicle

  @@number_of_vehicles = 0

  attr_reader :year, :model
  attr_accessor :color
  
  def initialize(year, model, color)
    @year = year
    @color = color
    @model = model
    @speed = 0
    @@number_of_vehicles += 1
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
  
  def self.gas_mileage(litres, km)
    puts "#{km/litres} km/L of gas"
  end

  def self.number_of_vehicles
    puts "There are #{@@number_of_vehicles} vehicles"
  end

  def age
    "Your #{model} is #{years_old} years old."
  end

  private

  def years_old
    Time.now.year - self.year
  end
end


class MyCar < Vehicle

  NUMBER_OF_DOORS = 4
  
  # Class Methods
  def to_s
    "This car is a #{color}, #{year}, #{@model}"
  end

end

class MyTruck < Vehicle
  include Towable
  NUMBER_OF_DOORS = 2

  # Class Methods
  def to_s
    "This truck is a #{color}, #{year}, #{@model}"
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
puts lumina.age 
lumina.spray_paint('red')
MyCar.gas_mileage(13, 351)  # => "27 miles per gallon of gas"
my_car = MyCar.new("2010", "Ford Focus", "silver")
puts my_car
puts Vehicle.number_of_vehicles

puts MyCar.ancestors
puts MyTruck.ancestors
puts Vehicle.ancestors