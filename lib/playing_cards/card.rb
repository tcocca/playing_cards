module PlayingCards
  class Card
    include Comparable

    class InvalidCardError < StandardError; end

    RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)
    SUITS = %w(spade heart club diamond)
    COLORS = {'spade' => :black, 'club' => :black, 'heart' => :red, 'diamond' => :red}
    VALUES = {'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14}
    NAMES = {'A' => 'Ace', 'J' => 'Jack', 'Q' => 'Queen', 'K' => 'King'}

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

    def color
      COLORS[self.suit].to_s
    end

    def value
      VALUES[self.rank] || self.rank.to_i
    end
    alias to_i value

    def rank_name
      NAMES[self.rank] || self.rank
    end

    def name
      "#{rank_name} of #{self.suit.capitalize}s"
    end
    alias to_s name

    def <=>(other_card)
      self.value <=> other_card.value
    end

    def self.card_combinations
      RANKS.product(SUITS)
    end

  end
end
