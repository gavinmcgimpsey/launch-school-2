class CardGame
  attr_reader :shoe, :players

  def initialize(players: [Human.new], num_decks: 1, num_hands: 1, num_cards: 0)
    @shoe = Shoe.new(num_decks)
    @players = players

    self.players.each { |player| num_hands.times { player.new_hand } }
    shoe.shuffle!
    self.players.each do |player|
      player.hands.each do |hand|
        hand.add(shoe.deal(num_cards))
      end
    end
  end
end
