# Tic Tac Toe game
# Exercise for Tealeaf Lesson 2

def clear_screen
  system "clear" or system "cls"
end

class Board
  attr_reader :values

  def initialize(*starting_values)
    if starting_values[0]
      @values = Hash.new { |hash, key| hash[key] = starting_values[0][key - 1] }
    else
      @values = { 1 => ' ', 2 => ' ', 3 => ' ', 4 => ' ', 5 => ' ', 6 => ' ', 7 => ' ', 8 => ' ', 9 => ' ' }
    end
  end

  def display
    puts " #{@values[1]} | #{@values[2]} | #{@values[3]} "
    puts "---|---|---"
    puts " #{@values[4]} | #{@values[5]} | #{@values[6]} "
    puts "---|---|---"
    puts " #{@values[7]} | #{@values[8]} | #{@values[9]} "
  end

  def valid_play?(square)
    @values[square] == ' '
  end

  def place(square, symbol)
    if valid_play?(square)
      @values[square] = symbol
    else
      false
    end
  end

  def full?
    !@values.values.include?(' ')
  end

  def three_in_a_row?
    three_possibilities = [[1, 2, 3], [4, 5, 6], [7, 8, 9], # Horizontals
                           [1, 4, 7], [2, 5, 8], [3, 6, 9], # Verticals
                           [1, 5, 9], [3, 5, 7]] # Diagonals

    three_possibilities.each do |squares|
      contents = [@values[squares[0]], @values[squares[1]], @values[squares[2]]].uniq
      if contents.length == 1 && contents[0] != " "
        return [@values[squares[0]], squares]
      end
    end
    false # falls through
  end
end

class Game
  attr_accessor :current_player, :board, :players
  attr_reader :human, :computer

  def initialize
    @human = Human.new(ask_for_name, 'X')
    @computer = Computer.new("Computer", 'O')
    @players = [@human, @computer]
  end

  def self.options
    (1..9).to_a
  end
  @@key_board = Board.new(options)

  def ask_for_name
    puts "What's your name?"
    gets.chomp
  end

  def play
    loop do
      self.board = Board.new
      turns = 0
      loop do
        self.current_player = players[turns % 2]
        take_turn
        break if game_over
        turns += 1
      end
      display_winner(game_over)
      break unless play_again?
    end
  end

  def take_turn
    loop do
      clear_screen
      board.display
      puts
      choice = current_player.pick_option.to_i
      symbol = current_player.marker
      break if board.place(choice, symbol)
    end
  end

  def self.display_options
    @@key_board.display
  end

  def game_over
    board.three_in_a_row? || board.full?
  end

  def display_winner(winner)
    clear_screen
    board.display
    if winner[0] == 'X'
      puts "#{human.name} wins!"
      puts "Three in a row in slots #{winner[1][0]}, #{winner[1][1]}, and #{winner[1][2]}."
    elsif winner[0] == 'O'
      puts "Oh no! The computer won!"
      puts "Three in a row in slots #{winner[1][0]}, #{winner[1][1]}, and #{winner[1][2]}."
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    puts "Want to play again? (y/n)"
    response = gets.chomp.downcase
    response == 'y'
  end
end

class Player
  attr_reader :name, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end

  def greet
    puts "Hi, #{name}!"
  end
end

class Human < Player
  def pick_option
    puts "Choose one:"
    Game.display_options
    puts
    gets.chomp
  end
end

class Computer < Player
  def pick_option
    Game.options.sample
  end
end

Game.new.play
