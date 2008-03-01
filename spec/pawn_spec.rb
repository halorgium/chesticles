require File.dirname(__FILE__) + '/spec_helper.rb'

describe Pawn do
  include BoardHelpers

  it "should implement the legal_move?(move) slot" do
    p = Pawn.new(Square.new(1,1), Player.white, boards(:start))
    p.send(:legal_move?, p.move_for(Square.new(1,0)))
  end
end
