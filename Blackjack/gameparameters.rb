module GameParameters
  GAME_NAME = "Blackjack"
  INIT = "BlackjackGame.new(players: @players, num_decks: 3)"

  CARD_SUITS = ["S", "H", "D", "C"]
  CARD_VALUES = { "2" => 2, "3" => 3, "4" => 4, "5" => 5,
                  "6" => 6, "7" => 7, "8" => 8, "9" => 9,
                  "T" => 10, "J" => 10, "Q" => 10,
                  "K" => 10, "A" => 11 }

  MISC = {}

  def self.card_names
    CARD_VALUES.keys
  end

  def self.card_value(card)
    CARD_VALUES[card.name]
  end
end
