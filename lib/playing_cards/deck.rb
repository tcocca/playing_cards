module PlayingCards
  class Deck
    class NotEnoughCardsError < StandardError; end
    class NotDrawnCardError < StandardError; end
    class InvalidDeckStateError < StandardError; end

    attr_reader :cards, :discards, :drawn_cards, :options

    def initialize(options = {})
      @options = options
      @cards = []
      @discards = []
      @drawn_cards = []
      if options[:cards] || options[:discards] || options[:drawn_cards]
        restore_deck_from_options
      else
        (Card.card_combinations * number_of_decks).each do |card_combination|
          @cards << Card.new(card_combination[0], card_combination[1])
        end
      end
    end

    def number_of_decks
      @options.fetch(:num_decks, 1)
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
      @drawn_cards += draws
      draws
    end

    def discard(card)
      card_pos = drawn_cards.index(card)
      if card_pos && drawn_card = drawn_cards.delete_at(card_pos)
        @discards << card
      else
        raise NotDrawnCardError
      end
    end

    def reuse_discards(shuffle_cards = true)
      if cards_remaining == 0
        @cards += discards
        @discards = []
        self.shuffle! if shuffle_cards
        @cards
      end
    end

    def dump_state
      cards_state = cards.collect{|c| c.state}
      discards_state = discards.collect{|c| c.state}
      drawn_cards_state = drawn_cards.collect{|c| c.state}
      [cards_state, discards_state, drawn_cards_state]
    end

    private

    def restore_deck_from_options
      restore_cards = options.delete(:cards) || []
      restore_discards = options.delete(:discards) || []
      restore_drawn_cards = options.delete(:drawn_cards) || []
      restore_deck = restore_cards + restore_discards + restore_drawn_cards
      sorted_restore_deck = restore_deck.sort{|a,b| a <=> b}
      unless sorted_restore_deck == (Card.card_combinations * number_of_decks).sort{|a,b| a <=> b}
        raise InvalidDeckStateError
      end
      unless restore_cards.empty?
        restore_cards.each do |card_combination|
          @cards << Card.new(card_combination[0], card_combination[1])
        end
      end
      unless restore_discards.empty?
        restore_discards.each do |card_combination|
          @discards << Card.new(card_combination[0], card_combination[1])
        end
      end
      unless restore_drawn_cards.empty?
        restore_drawn_cards.each do |card_combination|
          @drawn_cards << Card.new(card_combination[0], card_combination[1])
        end
      end
    end

  end
end
