# frozen_string_literal: true

module ErrorMessages
  def invalid_guess_error
    "Your guess is invalid. Choose any letter between a-z that's not previously chosen"
  end

  def existing_guess_error
    "You have previously made that guess. Choose any letter between a-z that's not previously chosen"
  end
end
