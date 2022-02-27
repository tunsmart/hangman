# frozen_string_literal: true

class Hangman
  attr_accessor :current_guesses, :wrong_guesses, :word_to_guess, :tries, :blanked_word, :player

  include ErrorMessages
  include Display

  dictionary = []
  File.open('words.txt', 'r') do |f|
    f.readlines.each { |word| dictionary << word if word.length > 5 || word.length <= 13 }
  end
  @@word = dictionary.sample.split('')[0...-1]
  @@blanked = Array.new(@@word.length, '_')

  def initialize(player, word_to_guess = @@word, blanked_word = @@blanked, current_guesses = [], wrong_guesses = [], tries = 10)
    @player = player
    @word_to_guess = word_to_guess
    @blanked_word = blanked_word
    @current_guesses = current_guesses
    @wrong_guesses = wrong_guesses
    @tries = tries
  end

  def update_blanked_word(guess)
    letter_indices = []
    word_to_guess.each_with_index { |letter, index| letter_indices << index if letter == guess }
    letter_indices.each { |index| blanked_word[index] = guess }
  end

  def update_wrong_guess(guess)
    wrong_guesses << guess unless word_to_guess.any?(guess)
  end

  def update_current_guess(guess)
    current_guesses << guess
  end

  def get_guess
    begin
      guess = player.make_a_guess
      raise invalid_guess_error unless valid_guesses.any?(guess) || guess == 'save'
      raise existing_guess_error if current_guesses.any?(guess) && guess != 'save'
    rescue StandardError => e
      puts e
      retry
    end
    guess
  end

  def valid_guesses
    ('a'..'z').to_a
  end

  def all_guessed?
    blanked_word.none?('_')
  end

  def play
    while tries.positive?
      display_word
      guess = get_guess
      if guess == 'save'
        save_game
        break
      end
      update_current_guess(guess)
      update_blanked_word(guess)
      update_wrong_guess(guess)
      if all_guessed?
        puts 'You won'
        display_word
        File.delete("saved_games/#{player.username.downcase}")
        break
      end
      self.tries -= 1
    end
    puts "You lost! Correct word is: '#{word_to_guess.join.capitalize}'" unless guess == 'save' || all_guessed?
  end

  def to_yaml
    YAML.dump({
                current_guesses: current_guesses,
                wrong_guesses: wrong_guesses,
                word_to_guess: word_to_guess,
                tries: tries,
                blanked_word: blanked_word,
                player: player
              })
  end

  def save_game
    File.open("saved_games/#{player.username.downcase}", 'w+') do |f|
      f.write(to_yaml)
    end
  end

  def self.load_game(path)
    file = File.open(path, 'r', &:read)
    data = YAML.safe_load(file)
    new(data[:player],
        data[:word_to_guess],
        data[:blanked_word],
        data[:current_guesses],
        data[:wrong_guesses],
        data[:tries])
  end
end
