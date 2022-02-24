
module ErrorMessages
    def invalid_guess_error
        "Your guess is invalid. Choose any letter between a-z that's not previously chosen"
    end

    def existing_guess_error
        "You have previously made that guess. Choose any letter between a-z that's not previously chosen"
    end
end

module Guessables
    def dictionary
        words = File.open("words.txt", "r"){|f| f.readlines}
        dictionary = []
        words.each{|word| dictionary << word if word.length > 5 || word.length <= 13}
        dictionary
    end
    def valid_guesses
        ("a".."z").to_a
    end
end

module Display
    include Guessables

    def display_greetings_and_instructions
        
    end

    def display_word
        puts "#{blanked_word}\n Wrong guesses: #{wrong_guesses}\n Tries left: #{tries}"
    end
end

class Player
    include ErrorMessages
    include Guessables
    attr_accessor :make_a_guess
    def initialize(username)
        @username = username
    end

    def make_a_guess
        begin
            guess = gets.chomp.downcase
            raise invalid_guess_error unless valid_guesses.any?(guess) 
        rescue => exception
            puts exception
            retry
        end
        guess
    end
end

class Hangman
    attr_accessor :current_guesses, :wrong_guesses, :word_to_guess, :tries, :blanked_word, :player
    include ErrorMessages
    include Guessables
    include Display

    def initialize(player)
        @player = player
        @word_to_guess = dictionary.sample.split('')[0...-1]
        @blanked_word = Array.new(@word_to_guess.length, "_")
        @current_guesses = []
        @wrong_guesses = []
        @tries = 6
    end

    def update_blanked_word(guess)
        letter_indices = [] 
        word_to_guess.each_with_index{|letter,index| letter_indices << index if letter == guess}
        letter_indices.each{|index| blanked_word[index] = guess}
    end

    def update_wrong_guess (guess)
        wrong_guesses << guess unless word_to_guess.any?(guess)
    end

    def update_current_guess(guess)
        current_guesses << guess
    end

    def get_guess
        begin
            guess = player.make_a_guess
            raise existing_guess_error if current_guesses.any?(guess)
        rescue => exception
            puts exception
            retry
        end
        guess
    end

    def all_guessed?
        !blanked_word.any?("_")
    end

    def play
        display_greetings_and_instructions
        while tries > 0
            display_word
            guess = get_guess
            update_current_guess(guess)
            update_blanked_word(guess)
            update_wrong_guess(guess)
            if all_guessed?
                puts "You won"
                display_word
                break
            end
            self.tries -= 1
        end
        puts "You lost! Correct word is: '#{word_to_guess.join.capitalize}'"
    end

end

player1 = Player.new("Jake")
new_game = Hangman.new(player1)
new_game.play