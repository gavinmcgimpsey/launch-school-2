class Player # new_hand, fold_hand
  attr_reader :hands, :name

  def initialize(name: '')
    @hands = []
    @name = name
  end

  def new_hand(*cds)
    @hands << Hand.new(cds)
  end

  def fold_hand(hand)
    @hands.delete(hand)
  end

  def get_hand_with_status(status)
    hands.each do |hand|
      return hand if hand.status == status
    end
    nil
  end
end

class Human < Player
  @@humans = 0

  def initialize
    @@humans += 1
    super(name: ask_for_name)
  end

  def ask_for_name
    puts "Hi, player #{@@humans}! What's your name?"
    gets.chomp.capitalize
  end

  def get_choice(*opts)
    options = opts.flatten.reduce({}, :merge)
    puts "What would you like to do?"
    puts
    options.each { |key, val| puts "(#{key}) #{val}" }
    puts
    response = gets.chomp
    unless options.keys.include?(response)
      response = get_choice(options)
    end
    response
  end
end
