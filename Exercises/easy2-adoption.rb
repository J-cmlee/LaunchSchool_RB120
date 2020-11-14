class Pet
  attr_reader :name, :animal

  def initialize(animal, name)
    @animal = animal
    @name = name
  end

end

class Owner
  attr_accessor :name, :animals

  def initialize(name)
    @name = name
    @animals = []
  end

  def number_of_pets
    @animals.length
  end

end

class Shelter
  def initialize
    @owner_list = []
  end
  def adopt(owner, animal)
    owner.animals << animal
    unless @owner_list.include?(owner)
      @owner_list << owner
    end
  end

  def print_adoptions
    @owner_list.each do |owner|
      puts "#{owner.name} has adopted the following pets:"
      owner.animals.each do |pet|
        puts "a #{pet.animal} named #{pet.name}"
      end
      puts ""
    end
  end

end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."