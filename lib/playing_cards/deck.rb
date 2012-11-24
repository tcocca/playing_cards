module PlayingCards
  class Deck
    class NotEnoughCardsError < StandardError; end

    attr_reader :cards, :discards, :drawn_cards

    def initialize(options = {})
      @cards = []
      @discards = []
      @drawn = []
      num_decks = options.delete(:num_decks) || 1
      (Card.card_combinations * num_decks).each do |card_combination|
        @cards << Card.new(card_combination[0], card_combination[1])
      end
    end

    def cards_remaining
      cards.size
    end

    def shuffle!
      cards.shuffle!
    end

    def cut
      top_cut, bottom_cut = split
      @cards = bottom_cut + top_cut
    end

    def split
      x = rand(cards_remaining)
      top_cut = cards.slice(0..x)
      bottom_cut = cards.slice(x+1..cards.size-1)
      [top_cut, bottom_cut]
    end

    def draw(num = 1)
      raise NotEnoughCardsError if num > cards_remaining
      draws = cards.shift(num)
      @drawn += draws
      draws
    end

    def discard(card)
      @discards << card
    end

    def reuse_discards(shuffle_cards = true)
      if cards_remaining == 0
        @cards += discards
        @discards = []
        self.shuffle! if shuffle_cards
        @cards
      end
    end

  end
end
