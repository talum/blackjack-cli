class Game 
  attr_accessor :deck 
  SUITS = ["Hearts", "Diamonds", "Clubs", "Spades"]
  POSSIBLE_FACES = [2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King", "Ace"]

  def initialize
    @deck = make_deck.shuffle!
    @player1 = Player.new("Player1")
    @player2 = Player.new("Player2")
    @current_player = @player1
    welcome
    @game_over = false 
    until @game_over 
      player_turn 
    end
    declare_winner
  end

  def make_deck
    @deck = []
    SUITS.each do |suit|
      POSSIBLE_FACES.each do |face|
        @deck << Card.new(suit, face)
      end
    end
    @deck 
  end

  def welcome
    puts "Welcome to Blackjack. "
  end

  def player_turn
    2.times do 
      deal_card
    end
    prompt_user
  end

  def prompt_user 
    puts "#{@current_player.name}, it is now your turn."
    @current_player.display_hand 
    puts "Your score is #{@current_player.score}"
    turn_over = check_score
    until turn_over 
      puts "Press 'h' to hit or 's' to stay."
      response = gets.chomp 
      if response == 'h'
        deal_card
        @current_player.display_hand 
        puts "Your score is #{@current_player.score}"
        turn_over = check_score
      elsif response == 's'
        turn_over = true
      else
        puts "Sorry, don't recognize that command. Please try again."
      end
    end
    switch_player 
  end

  def switch_player
    if @current_player == @player1
      @current_player = @player2
    else
      @game_over = true
    end
  end

  def check_score
    if @current_player.score >= 21
      true
    end
  end

  def deal_card
    @current_player.hand << @deck.sample
  end

  def declare_winner
    player1_diff = 21 - @player1.score
    player2_diff = 21 - @player2.score 
    if player1_diff > 0 && player2_diff > 0
      if player1_diff < player2_diff
        puts "Player 1 wins!"
      elsif player1_diff == player2_diff
        puts "You tie!"
      else
        puts "Player 2 wins!"
      end
    else
      if player1_diff > 0 
        puts "Player 1 wins"
      elsif player2_diff > 0
        puts "Player 2 wins"
      else 
        puts "You both lose."
      end
    end
  end

end

class Player
  #has a hand 
  attr_accessor :name, :hand

  def initialize(name)
    @hand = []
    @name = name
  end

  def display_hand 
    puts "This is your hand:"
    self.hand.each do |card|
      puts "#{card.face} of #{card.suit}"
    end
  end

  def score 
    self.hand.map{|card| card.value}.inject{|sum, card_val| sum + card_val}
  end
end

class Card

  attr_accessor :suit, :face
  FACES = ["Jack", "Queen", "King", "Ace"]
  
  def initialize(suit, face)
    @suit = suit
    @face = face  
  end

  def value
    if FACES.include?(self.face)
      value = 11
    else
      value = face.to_i
    end
    value  
  end
end

Game.new