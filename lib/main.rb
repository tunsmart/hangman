require 'yaml'
require_relative 'display'
require_relative 'error_messages'
require_relative 'player'
require_relative 'hangman'

def play_new_game(username)
    player = Player.new(username)
    new_game = Hangman.new(player)
    new_game.play
end

Display::display_greetings_and_instructions
puts "Type in a unique username"
username = gets.chomp.downcase
if Dir.children("saved_games").any?(username)
    puts "Welcome back #{username.capitalize}, wanna resume from where you stopped?\n
            Type Y or Yes to resume previous game or N or No to start a new game"
    response = gets.chomp.downcase
    if response == 'y' || response == 'yes'
        loaded_game = Hangman.load_game("saved_games/#{username}")
        loaded_game.play
    else
       play_new_game(username)
    end
else
    puts "Welcome #{username.capitalize}"
    play_new_game(username)
end

