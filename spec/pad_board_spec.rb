require 'pad_board'

describe PadBoard do
  it "initialize" do
    expect(PadBoard.new.board.size).to eq(30)
  end
  it "each_row" do
    pad = PadBoard.new

    rows = []
    pad.each_row do |row|
      rows << row
    end
    expect(rows[0]).to eq(pad.board[0,6])
  end
  it "each_column" do
    pad = PadBoard.new

    columns = []
    pad.each_column do |column|
      columns << column
    end

    expect(columns[0]).to eq([pad.board[0],pad.board[6],pad.board[12],pad.board[18],pad.board[24]])
    expect(columns[5]).to eq([pad.board[0+5],pad.board[6+5],pad.board[12+5],pad.board[18+5],pad.board[24+5]])
  end

  it "is_sequence" do
    expect(PadBoard.no_sequence_board.is_sequence?).to be_false
  end

  it "coord" do
    expect(PadBoard.coord(4)).to eq([4,0])
    expect(PadBoard.coord(6)).to eq([0,1])
  end
  it "pos" do
    expect(PadBoard.pos(4,0)).to eq(4)
    expect(PadBoard.pos(2,2)).to eq(14)
  end
  it "arounds #1" do
    expect(PadBoard.arounds(0,0)).to eq([[0,1],[1,0]])
  end
  it "arounds #2" do
    expect(PadBoard.arounds(5,5)).to eq([[5,4],[4,5]])
  end
  it "arounds #3" do
    expect(PadBoard.arounds(3,0)).to eq([[3,1],[2,0],[4,0]])
  end
  #it "sequence_combination_by_swap" do
  #  pad = PadBoard.new
  #  expect(pad.sequence_combination_by_swap).to eq([])
  #end
end
