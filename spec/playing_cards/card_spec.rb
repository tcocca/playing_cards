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
    it "should return 1 for aces" do
      PlayingCards::Card.new('A', 'heart').value.should == 1
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

    it "should return the rank as an integer for number cards" do
      (2..10).each do |rank|
        PlayingCards::Card.new(rank.to_s, 'heart').value.should == rank
      end
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
