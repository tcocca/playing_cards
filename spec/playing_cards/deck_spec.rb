require 'spec_helper'

describe PlayingCards::Deck do
  let(:deck) {PlayingCards::Deck.new}

  context "new deck" do
    it "should create an array of cards" do
      deck.cards.should be_a(Array)
      deck.cards.first.should be_a(PlayingCards::Card)
    end

    it "should accept a number of decks option" do
      deck.cards.size.should == 52
      PlayingCards::Deck.new(:num_decks => 1).cards.size.should == 52
      PlayingCards::Deck.new(:num_decks => 2).cards.size.should == 104
      PlayingCards::Deck.new(:num_decks => 3).cards.size.should == 156
    end

    it "should allow creating a deck from a restored state" do
      restore_deck = PlayingCards::Deck.new(
        :cards => [["2", "heart"],["2", "club"], ["2", "diamond"]],
        :discards => [
          ["3", "spade"], ["3", "heart"], ["3", "club"], ["3", "diamond"],
          ["4", "spade"], ["4", "heart"], ["4", "club"], ["4", "diamond"],
          ["5", "spade"], ["5", "heart"], ["5", "club"], ["5", "diamond"],
          ["6", "spade"], ["6", "heart"], ["6", "club"], ["6", "diamond"],
          ["7", "spade"], ["7", "heart"], ["7", "club"], ["7", "diamond"],
          ["8", "spade"], ["8", "heart"], ["8", "club"], ["8", "diamond"],
          ["9", "spade"], ["9", "heart"], ["9", "club"], ["9", "diamond"],
          ["10", "spade"], ["10", "heart"], ["10", "club"], ["10", "diamond"],
          ["J", "spade"], ["J", "heart"], ["J", "club"], ["J", "diamond"],
          ["Q", "spade"], ["Q", "heart"], ["Q", "club"], ["Q", "diamond"],
          ["K", "spade"], ["K", "heart"], ["K", "club"], ["K", "diamond"],
          ["A", "spade"], ["A", "heart"], ["A", "club"], ["A", "diamond"]
        ],
        :drawn_cards => [["2", "spade"]]
      )
      restore_deck.cards.size.should == 3
      restore_deck.discards.size.should == 48
      restore_deck.drawn_cards.size.should == 1
    end

    it "should raise an error when given an invalid state" do
      expect {
        PlayingCards::Deck.new(
          :cards => [['2', 'heart'],["2", "club"], ["2", "diamond"]]
        )
      }.to raise_error PlayingCards::Deck::InvalidDeckStateError
      expect {
        PlayingCards::Deck.new(
          :cards => [['2', 'heart'],["2", "club"], ["2", "diamond"]],
          :discards => [
            ["3", "spade"], ["3", "heart"], ["3", "club"], ["3", "diamond"],
            ["4", "spade"], ["4", "heart"], ["4", "club"], ["4", "diamond"],
            ["5", "spade"], ["5", "heart"], ["5", "club"], ["5", "diamond"],
            ["6", "spade"], ["6", "heart"], ["6", "club"], ["6", "diamond"],
            ["7", "spade"], ["7", "heart"], ["7", "club"], ["7", "diamond"],
            ["8", "spade"], ["8", "heart"], ["8", "club"], ["8", "diamond"],
            ["9", "spade"], ["9", "heart"], ["9", "club"], ["9", "diamond"],
            ["10", "spade"], ["10", "heart"], ["10", "club"], ["10", "diamond"],
            ["J", "spade"], ["J", "heart"], ["J", "club"], ["J", "diamond"],
            ["Q", "spade"], ["Q", "heart"], ["Q", "club"], ["Q", "diamond"],
            ["K", "spade"], ["K", "heart"], ["K", "club"], ["K", "diamond"],
            ["A", "spade"], ["A", "heart"], ["A", "club"], ["A", "diamond"]
          ],
          :drawn_cards => [["2", 'spade'],["2", 'spade']]
        )
      }.to raise_error PlayingCards::Deck::InvalidDeckStateError
    end

    it "should take allow restoring with a number of decks" do
      restore_deck = PlayingCards::Deck.new(
        :cards => [
          ["2", "spade"],["2", "heart"],["2", "club"], ["2", "diamond"],
          ["3", "spade"], ["3", "heart"], ["3", "club"], ["3", "diamond"],
          ["4", "spade"], ["4", "heart"], ["4", "club"], ["4", "diamond"],
          ["5", "spade"], ["5", "heart"], ["5", "club"], ["5", "diamond"],
          ["6", "spade"], ["6", "heart"], ["6", "club"], ["6", "diamond"],
          ["7", "spade"], ["7", "heart"], ["7", "club"], ["7", "diamond"],
          ["8", "spade"], ["8", "heart"], ["8", "club"], ["8", "diamond"],
          ["9", "spade"], ["9", "heart"], ["9", "club"], ["9", "diamond"],
          ["10", "spade"], ["10", "heart"], ["10", "club"], ["10", "diamond"],
          ["J", "spade"], ["J", "heart"], ["J", "club"], ["J", "diamond"],
          ["Q", "spade"], ["Q", "heart"], ["Q", "club"], ["Q", "diamond"],
          ["K", "spade"], ["K", "heart"], ["K", "club"], ["K", "diamond"],
          ["A", "spade"], ["A", "heart"], ["A", "club"], ["A", "diamond"]
        ],
        :drawn_cards => [
          ["2", "spade"],["2", "heart"],["2", "club"], ["2", "diamond"],
          ["3", "spade"], ["3", "heart"], ["3", "club"], ["3", "diamond"],
          ["4", "spade"], ["4", "heart"], ["4", "club"], ["4", "diamond"],
          ["5", "spade"], ["5", "heart"], ["5", "club"], ["5", "diamond"],
          ["6", "spade"], ["6", "heart"], ["6", "club"], ["6", "diamond"],
          ["7", "spade"], ["7", "heart"], ["7", "club"], ["7", "diamond"],
          ["8", "spade"], ["8", "heart"], ["8", "club"], ["8", "diamond"],
          ["9", "spade"], ["9", "heart"], ["9", "club"], ["9", "diamond"],
          ["10", "spade"], ["10", "heart"], ["10", "club"], ["10", "diamond"],
          ["J", "spade"], ["J", "heart"], ["J", "club"], ["J", "diamond"],
          ["Q", "spade"], ["Q", "heart"], ["Q", "club"], ["Q", "diamond"],
          ["K", "spade"], ["K", "heart"], ["K", "club"], ["K", "diamond"],
          ["A", "spade"], ["A", "heart"], ["A", "club"], ["A", "diamond"]
        ],
        :num_decks => 2
      )
      restore_deck.cards.size.should == 52
      restore_deck.discards.size.should == 0
      restore_deck.drawn_cards.size.should == 52
    end

    it "should raise error when given a valid deck but less than the number specified" do
      expect {
        PlayingCards::Deck.new(
          :cards => [
            ["2", "spade"],["2", "heart"],["2", "club"], ["2", "diamond"],
            ["3", "spade"], ["3", "heart"], ["3", "club"], ["3", "diamond"],
            ["4", "spade"], ["4", "heart"], ["4", "club"], ["4", "diamond"],
            ["5", "spade"], ["5", "heart"], ["5", "club"], ["5", "diamond"],
            ["6", "spade"], ["6", "heart"], ["6", "club"], ["6", "diamond"],
            ["7", "spade"], ["7", "heart"], ["7", "club"], ["7", "diamond"],
            ["8", "spade"], ["8", "heart"], ["8", "club"], ["8", "diamond"],
            ["9", "spade"], ["9", "heart"], ["9", "club"], ["9", "diamond"],
            ["10", "spade"], ["10", "heart"], ["10", "club"], ["10", "diamond"],
            ["J", "spade"], ["J", "heart"], ["J", "club"], ["J", "diamond"],
            ["Q", "spade"], ["Q", "heart"], ["Q", "club"], ["Q", "diamond"],
            ["K", "spade"], ["K", "heart"], ["K", "club"], ["K", "diamond"],
            ["A", "spade"], ["A", "heart"], ["A", "club"], ["A", "diamond"]
          ],
          :num_decks => 2
        )
      }.to raise_error PlayingCards::Deck::InvalidDeckStateError
    end

  end

  context "number_of_decks" do
    it "should return 1 by default" do
      deck.number_of_decks.should == 1
      deck.options[:num_decks].should == nil
    end

    it "should return the number passed in" do
      one_deck = PlayingCards::Deck.new(:num_decks => 1)
      one_deck.number_of_decks.should == 1
      one_deck.options[:num_decks].should == 1
      two_deck = PlayingCards::Deck.new(:num_decks => 2)
      two_deck.number_of_decks.should == 2
      two_deck.options[:num_decks].should == 2
      three_deck = PlayingCards::Deck.new(:num_decks => 3)
      three_deck.number_of_decks.should == 3
      three_deck.options[:num_decks].should == 3
    end
  end

  context "cards_remaining" do
    it "should return the number of cards left in the deck" do
      deck.cards_remaining.should == 52
      deck.cards.pop
      deck.cards_remaining.should == 51
      two_decks = PlayingCards::Deck.new(:num_decks => 2)
      two_decks.cards_remaining.should == 104
      two_decks.cards.pop
      two_decks.cards_remaining.should == 103
    end
  end

  context "shuffle!" do
    it "should shuffle the array of cards" do
      #deck.cards.should_receive(:shuffle!)
      cards_stub = double("cards")
      deck.stub(:cards).and_return(cards_stub)
      cards_stub.should_receive(:shuffle!)
      deck.shuffle!
    end
  end

  context "split" do
    it "should return 2 arrays that have the same cards as the deck" do
      top, bottom = deck.split
      top.should be_a(Array)
      bottom.should be_a(Array)
      (top.size + bottom.size).should == deck.cards.size
      (top + bottom).sort{|a,b| a.suit <=> b.suit}.sort{|a,b| a <=> b}.should == deck.cards.sort{|a,b| a.suit <=> b.suit}.sort{|a,b| a <=> b}
    end
  end

  context "cut" do
    it "should reorder the split cards so that the bottom half is now the top half" do
      old_cards = deck.cards.dup
      deck.cut.should be_a(Array)
      deck.cards.size.should == old_cards.size
    end
  end

  context "draw" do
    it "should default to giving 1 card off the top of the pile" do
      count = deck.cards_remaining
      old_cards = deck.cards.dup
      cards = deck.draw
      cards.should be_a(Array)
      cards.size.should == 1
      cards.first.should == old_cards.first
      deck.cards.size.should == (old_cards.size - 1)
    end

    it "should accept a number of cards to draw" do
      count = deck.cards_remaining
      old_cards = deck.cards.dup
      cards = deck.draw(2)
      cards.should be_a(Array)
      cards.size.should == 2
      cards.should == old_cards[0..1]
      deck.cards.size.should == (old_cards.size - 2)
    end

    it "should raise an error when there are not enough cards" do
      expect { deck.draw(53) }.to raise_error PlayingCards::Deck::NotEnoughCardsError
    end

    it "should not raise an error when there are enough cards" do
      expect { deck.draw(52) }.to_not raise_error
    end

    it "should increment the drawn cards array" do
      draw_1 = deck.draw
      deck.drawn_cards.size.should == 1
      deck.drawn_cards.should == draw_1
      draw_2 = deck.draw(2)
      deck.drawn_cards.size.should == 3
      deck.drawn_cards.should == [draw_1, draw_2].flatten
    end
  end

  context "discard" do
    it "should add the card to the discards pile" do
      card = deck.draw.first
      deck.discards.size.should == 0
      deck.discard(card)
      deck.discards.size.should == 1
      deck.discards.should == [card]
      second_card = deck.draw.first
      deck.discard(second_card)
      deck.discards.size.should == 2
      deck.discards.should == [card, second_card]
    end

    it "should only allow cards to be discarded that have been drawn" do
      card = PlayingCards::Card.new(2, 'spade')
      expect { deck.discard(card) }.to raise_error PlayingCards::Deck::NotDrawnCardError
    end

    it "should only allow cards to be discarded that have been drawn" do
      card = deck.draw.first
      expect { deck.discard(card) }.to_not raise_error
    end

    it "should only allow cards to be discarded that have been drawn once" do
      card = deck.draw.first
      expect { deck.discard(card) }.to_not raise_error
      expect { deck.discard(card) }.to raise_error PlayingCards::Deck::NotDrawnCardError
    end

    it "should allow the same card to be discarded if there are multiple decks" do
      multi_deck = PlayingCards::Deck.new(:num_decks => 2)
      draw_1 = multi_deck.draw
      draw_2 = multi_deck.draw(52)
      draw_1.first.should == draw_2.last
      expect { multi_deck.discard(draw_1.first) }.to_not raise_error
      expect { multi_deck.discard(draw_2.last) }.to_not raise_error
      expect { multi_deck.discard(draw_1.first) }.to raise_error PlayingCards::Deck::NotDrawnCardError
    end
  end

  context "reuse_discards" do
    it "should not do anything if there are still cards in the pile" do
      cards = deck.cards.dup
      discards = deck.discards.dup
      deck.reuse_discards
      deck.cards.should == cards
      deck.discards.should == discards
    end

    it "should move the discards back to the cards pile and shuffle by default" do
      cards = deck.draw(52)
      cards.each do |card|
        deck.discard(card)
      end
      deck.cards.size.should == 0
      deck.discards.size.should == 52
      deck.should_receive(:shuffle!).and_call_original
      deck.reuse_discards
      deck.cards.size.should == 52
      deck.discards.size.should == 0
    end

    it "should move the discards back to the cards pile and not shuffle when given false" do
      cards = deck.draw(52)
      cards.each do |card|
        deck.discard(card)
      end
      deck.cards.size.should == 0
      deck.discards.size.should == 52
      deck.should_not_receive(:shuffle!)
      deck.reuse_discards(false)
      deck.cards.size.should == 52
      deck.discards.size.should == 0
      deck.cards.should == cards
    end

    it "should only move the discarded cards back to the cards" do
      deck.shuffle!
      cards = deck.draw(52)
      cards.each_with_index do |card, i|
        next if i < 10
        deck.discard(card)
      end
      deck.cards.size.should == 0
      deck.discards.size.should == 42
      deck.reuse_discards
      deck.cards.size.should == 42
      deck.discards.size.should == 0
      cards.each_with_index do |card, i|
        found_card = deck.cards.find{|c| c.suit == card.suit && c.rank == card.rank}
        if i < 10
          found_card.should be_nil
        else
          found_card.should_not be_nil
        end
      end
    end
  end

  context "dump_state" do
    it "should return the state of the deck" do
      dumped_cards, dumped_discards, dumped_drawn_cards = deck.dump_state
      dumped_cards.should be_a(Array)
      dumped_cards.size.should == 52
      dumped_discards.should be_a(Array)
      dumped_discards.size.should == 0
      dumped_drawn_cards.should be_a(Array)
      dumped_drawn_cards.size.should == 0
    end

    it "should return the state after actions are performed" do
      cards = deck.draw(10)
      deck.discard(cards.first)
      deck.discard(cards.last)
      dumped_cards, dumped_discards, dumped_drawn_cards = deck.dump_state
      dumped_cards.size.should == 42
      dumped_cards.should == deck.cards.collect{|c| [c.rank, c.suit]}
      dumped_discards.size.should == 2
      dumped_discards.should == [[cards.first.rank, cards.first.suit], [cards.last.rank, cards.last.suit]]
      dumped_drawn_cards.size.should == 8
      dumped_drawn_cards.should == cards.slice(1..8).collect{|c| [c.rank, c.suit]}
    end
  end

end
