class GameEngine
  include GameParameters

  def initialize
    @num_players = GameParameters::MISC[:num_players] || ask_for_num_players
    @players = create_players
  end

  def play
    GameEngine.clear_screen
    greet
    loop do
      single_game = eval(GameParameters::INIT)
      single_game.play
      break unless play_again?
    end

    farewell
  end

  def play_again?
    puts "Want to play again? (y/n)"
    response = gets.chomp.downcase
    response == "y"
  end

  def create_players
    players = []
    @num_players.times do
      GameEngine.clear_screen
      players << Human.new
    end
    players
  end

  def farewell
    puts "Thanks for playing!"
  end

  def greet
    puts "Welcome to #{GameParameters::GAME_NAME}!"
  end

  def ask_for_num_players
    puts "How many players are there?"
    num_players = 0
    until num_players > 0
      num_players = gets.chomp.to_i
    end
    num_players
  end

  def self.heighten_suspense
    2.times do
      print "."
      sleep 0.3
    end
    print ". "
    sleep 0.5
    puts
  end

  def self.wait_to_continue
    puts "Press enter to continue"
    input = nil
    until input
      input = gets
    end
  end

  def self.clear_screen
    system "clear" or system "cls"
  end
end
