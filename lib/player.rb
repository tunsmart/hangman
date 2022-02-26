class Player
    attr_reader :username
    def initialize(username)
        @username = username
    end

    def make_a_guess
        gets.chomp.downcase
    end
end