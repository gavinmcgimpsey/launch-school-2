class Card
  attr_accessor :suit, :name

  def initialize(n, s)
    @name = n
    @suit = s
  end

  def to_s
    "#{name} of #{suit}"
  end
end

class Hand # add(card) display(hide: n)
  attr_accessor :status
  attr_reader :cards
  def initialize(*cds)
    if cds
      @cards = cds.flatten
    end
    @status = :active
  end

  def add(cd)
    @cards << cd
    @cards.flatten!
  end

  def delete(num)
    cds = []
    num.times { cds << cards.pop }
    cds
  end

  def display(hide: 0)
    hide.times { puts Card.new('?', '?').to_s }
    cards.drop(hide).each { |card| puts card }
  end
end

class Shoe # new(*decks), shuffle!, deal(*num)
  include GameParameters

  attr_reader :contents

  def initialize(*decks)
    @contents = []
    (decks[0] || 1).times do
      @contents.push(new_deck)
    end
    @contents.flatten!(1)
  end

  def shuffle!
    @contents.shuffle!
  end

  def deal(num = 1)
    cards_to_return = []
    num.times { cards_to_return << @contents.shift }
    cards_to_return
  end

  private

  def new_deck
    cards = GameParameters.card_names.product(GameParameters::CARD_SUITS)
    cards.map { |card| Card.new(card[0], card[1]) }
  end
end

class Deck < Shoe
  def initialize
    super(1)
  end
end
