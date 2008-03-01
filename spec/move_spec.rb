require File.dirname(__FILE__) + "/spec_helper.rb"

describe Move do
  it "should delegate #board and #player to #piece" do

    #the white kings pawn 
    p = Board.new.piece_for(Square.new(4, 6))
    m = p.move_for(Square.new(4,5))

    m.piece.should_receive(:board)
    m.board

    m.piece.should_receive(:player)
    m.player
    
  end
end