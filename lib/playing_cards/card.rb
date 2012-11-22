module PlayingCards
  class Card
    class InvalidCardError < StandardError; end

    RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)
    SUITS = %w(spade heart club diamond)
    COLORS = {'spade' => :black, 'club' => :black, 'heart' => :red, 'diamond' => :red}

    attr_reader :rank, :suit

    def initialize(rank, suit)
      @rank = rank.to_s == "1" ? "A" : rank.to_s.upcase
      @suit = suit.downcase
      raise InvalidCardError unless valid?
    end

    def valid?
      RANKS.include?(self.rank) && SUITS.include?(self.suit)
    end

    def red?
      COLORS[self.suit] == :red
    end

    def black?
      COLORS[self.suit] == :black
    end

    def self.card_combinations
      RANKS.product(SUITS)
    end

  end
end