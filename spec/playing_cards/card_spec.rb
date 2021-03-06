require 'spec_helper'

describe PlayingCards::Card do
  context "new card" do
    let(:card) { PlayingCards::Card.new('2', 'heart') }

    it "should be valid?" do
      card.valid?.should == true
    end
  end

  context "error handling" do
    it "should allow initialization with a rank and suit" do
      expect { PlayingCards::Card.new(2, 'diamond') }.to_not raise_error
    end

    it "should not allow initialization if given incorrect rank or suit" do
      expect { PlayingCards::Card.new(0, 'diamond') }.to raise_error PlayingCards::Card::InvalidCardError
      expect { PlayingCards::Card.new(0, 'none') }.to raise_error PlayingCards::Card::InvalidCardError
      expect { PlayingCards::Card.new(2, 'none') }.to raise_error PlayingCards::Card::InvalidCardError
    end

    it "should allow passing 1 as the rank for an ace" do
      expect { PlayingCards::Card.new(1, 'diamond') }.to_not raise_error
    end
  end

  context "colors" do
    it "should be #red?" do
      PlayingCards::Card.new('2', 'heart').red?.should be_true
      PlayingCards::Card.new('2', 'diamond').red?.should be_true
    end

    it "should not be #red?" do
      PlayingCards::Card.new('2', 'spade').red?.should_not be_true
      PlayingCards::Card.new('2', 'club').red?.should_not be_true
    end

    it "should be #black?" do
      PlayingCards::Card.new('2', 'spade').black?.should be_true
      PlayingCards::Card.new('2', 'club').black?.should be_true
    end

    it "should not be #black?" do
      PlayingCards::Card.new('2', 'heart').black?.should_not be_true
      PlayingCards::Card.new('2', 'diamond').black?.should_not be_true
    end

    it "should return the color" do
      PlayingCards::Card.new('2', 'heart').color.should == "red"
      PlayingCards::Card.new('2', 'diamond').color.should == "red"
      PlayingCards::Card.new('2', 'spade').color.should == "black"
      PlayingCards::Card.new('2', 'club').color.should == "black"
    end

    it "should give the color as a string" do
      PlayingCards::Card.new('2', 'heart').color.should be_a(String)
      PlayingCards::Card.new('2', 'diamond').color.should be_a(String)
      PlayingCards::Card.new('2', 'spade').color.should be_a(String)
      PlayingCards::Card.new('2', 'club').color.should be_a(String)
    end
  end

  context "value" do
    it "should return the rank as an integer for number cards" do
      (2..10).each do |rank|
        PlayingCards::Card.new(rank.to_s, 'heart').value.should == rank
      end
    end

    it "should return 11 for jacks" do
      PlayingCards::Card.new('J', 'heart').value.should == 11
    end

    it "should return 12 for queens" do
      PlayingCards::Card.new('Q', 'heart').value.should == 12
    end

    it "should return 13 for kings" do
      PlayingCards::Card.new('K', 'heart').value.should == 13
    end

    it "should return 14 for aces" do
      PlayingCards::Card.new('A', 'heart').value.should == 14
    end
  end

  context "to_i" do
    it "should return the value of the rank" do
      (2..10).each do |rank|
        PlayingCards::Card.new(rank.to_s, 'heart').value.should == rank
      end
      PlayingCards::Card.new('J', 'heart').value.should == 11
      PlayingCards::Card.new('Q', 'heart').value.should == 12
      PlayingCards::Card.new('K', 'heart').value.should == 13
      PlayingCards::Card.new('A', 'heart').value.should == 14
    end
  end

  context "names" do
    it "should return the rank name" do
      (2..10).each do |rank|
        PlayingCards::Card.new(rank.to_s, 'heart').rank_name.should == rank.to_s
      end
      PlayingCards::Card.new('J', 'heart').rank_name.should == 'Jack'
      PlayingCards::Card.new('Q', 'heart').rank_name.should == 'Queen'
      PlayingCards::Card.new('K', 'heart').rank_name.should == 'King'
      PlayingCards::Card.new('A', 'heart').rank_name.should == 'Ace'
    end

    it "should give a name for the card with rank name and suit" do
      {'heart' => 'Hearts', 'club' => 'Clubs', 'spade' => 'Spades', 'diamond' => 'Diamonds'}.each do |suit, suit_name|
        (2..10).each do |rank|
          PlayingCards::Card.new(rank, suit).name.should == "#{rank} of #{suit_name}"
        end
        PlayingCards::Card.new('J', suit).name.should == "Jack of #{suit_name}"
        PlayingCards::Card.new('Q', suit).name.should == "Queen of #{suit_name}"
        PlayingCards::Card.new('K', suit).name.should == "King of #{suit_name}"
        PlayingCards::Card.new('A', suit).name.should == "Ace of #{suit_name}"
      end
    end
  end

  context "to_s" do
    it "should return the name of the card" do
      {'heart' => 'Hearts', 'club' => 'Clubs', 'spade' => 'Spades', 'diamond' => 'Diamonds'}.each do |suit, suit_name|
        (2..10).each do |rank|
          PlayingCards::Card.new(rank, suit).name.should == "#{rank} of #{suit_name}"
        end
        PlayingCards::Card.new('J', suit).name.should == "Jack of #{suit_name}"
        PlayingCards::Card.new('Q', suit).name.should == "Queen of #{suit_name}"
        PlayingCards::Card.new('K', suit).name.should == "King of #{suit_name}"
        PlayingCards::Card.new('A', suit).name.should == "Ace of #{suit_name}"
      end
    end
  end

  context "comparable" do
    let(:compare_cards) do
      compare_cards = {}
      ['heart', 'club'].each do |suit|
        compare_cards[suit] = {}
        (2..10).each do |rank|
          compare_cards[suit][rank] = PlayingCards::Card.new(rank, suit)
        end
        compare_cards[suit]['J'] = PlayingCards::Card.new('J', suit)
        compare_cards[suit]['Q'] = PlayingCards::Card.new('Q', suit)
        compare_cards[suit]['K'] = PlayingCards::Card.new('K', suit)
        compare_cards[suit]['A'] = PlayingCards::Card.new('A', suit)
      end
      compare_cards
    end

    it "should return true or false for the equals comparison" do
      (compare_cards['heart']['A'] == compare_cards['club']['A']).should == false
      (compare_cards['heart']['K'] == compare_cards['club']['K']).should == false
      (compare_cards['heart'][2] == compare_cards['club'][2]).should == false
      (compare_cards['heart']['A'] == compare_cards['club']['K']).should == false
      (compare_cards['heart']['K'] == compare_cards['club']['A']).should == false
      (compare_cards['heart'][2] == compare_cards['club'][3]).should == false
      (compare_cards['heart']['A'] == compare_cards['heart']['A']).should == true
      (PlayingCards::Card.new(2, 'heart') == PlayingCards::Card.new(2, 'heart')).should == true
    end

    it "should return true or false for the > comparison" do
      (compare_cards['heart']['A'] > compare_cards['club']['A']).should == false
      (compare_cards['heart']['K'] > compare_cards['club']['K']).should == false
      (compare_cards['heart'][2] > compare_cards['club'][2]).should == false
      (compare_cards['heart']['A'] > compare_cards['club']['K']).should == true
      (compare_cards['heart']['K'] > compare_cards['club']['A']).should == false
      (compare_cards['heart'][2] > compare_cards['club'][3]).should == false
      (compare_cards['heart'][3] > compare_cards['club'][2]).should == true
    end

    it "should return true or false for the >= comparison" do
      (compare_cards['heart']['A'] >= compare_cards['club']['A']).should == true
      (compare_cards['heart']['K'] >= compare_cards['club']['K']).should == true
      (compare_cards['heart'][2] >= compare_cards['club'][2]).should == true
      (compare_cards['heart']['A'] >= compare_cards['club']['K']).should == true
      (compare_cards['heart']['K'] >= compare_cards['club']['A']).should == false
      (compare_cards['heart'][2] >= compare_cards['club'][3]).should == false
      (compare_cards['heart'][3] >= compare_cards['club'][2]).should == true
    end

    it "should return true or false for the < comparison" do
      (compare_cards['heart']['A'] < compare_cards['club']['A']).should == false
      (compare_cards['heart']['K'] < compare_cards['club']['K']).should == false
      (compare_cards['heart'][2] < compare_cards['club'][2]).should == false
      (compare_cards['heart']['A'] < compare_cards['club']['K']).should == false
      (compare_cards['heart']['K'] < compare_cards['club']['A']).should == true
      (compare_cards['heart'][2] < compare_cards['club'][3]).should == true
      (compare_cards['heart'][3] < compare_cards['club'][2]).should == false
    end

    it "should return true or false for the <= comparison" do
      (compare_cards['heart']['A'] <= compare_cards['club']['A']).should == true
      (compare_cards['heart']['K'] <= compare_cards['club']['K']).should == true
      (compare_cards['heart'][2] <= compare_cards['club'][2]).should == true
      (compare_cards['heart']['A'] <= compare_cards['club']['K']).should == false
      (compare_cards['heart']['K'] <= compare_cards['club']['A']).should == true
      (compare_cards['heart'][2] <= compare_cards['club'][3]).should == true
      (compare_cards['heart'][3] <= compare_cards['club'][2]).should == false
    end
  end

  context "state" do
    let(:card) { PlayingCards::Card.new('2', 'heart') }

    it "should return an array" do
      card.state.should be_a(Array)
    end

    it "should return an array of rank and suit" do
      card.state.should == ["2", "heart"]
    end
  end

  context "combinations" do
    it "should create an array of arrays of rank and suit combinations" do
      PlayingCards::Card.card_combinations.should == [
        ["2", "spade"], ["2", "heart"], ["2", "club"], ["2", "diamond"],
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
      ]
    end
  end
end
