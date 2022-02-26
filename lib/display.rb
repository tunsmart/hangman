
module Display
    def display_greetings_and_instructions
        puts <<-HEREDOC
            Welcome to Hangman.
            *******************
            Here are the rules...

            1. The computer will generate a random word with 5-12 letters
            2. You have ten tries to guess all the letters

            *************************************************************

        HEREDOC
    end

    def display_word
        puts <<-HEREDOC
            Word to guess---> #{blanked_word.join(" ")}
           ------------------------------------------
            Wrong guesses----> #{wrong_guesses}
           ------------------------------------------
            Tries left---------> #{tries}

            Type 'save' at any time to save your current game for later
        HEREDOC
    end
end