require 'pad_util'

describe PadUtil do
  it "success" do 
    expect([1,2,2,2,1].sequence).to eq([{pos:1,len:3,item:2}])
    expect([2,2,2,1].sequence).to eq([{pos:0,len:3,item:2}])
    expect([1,2,2,2].sequence).to eq([{pos:1,len:3,item:2}])
  end
  it "allsame" do 
    expect([2,2,2].sequence).to eq([{pos:0,len:3,item:2}])
  end
  it "not match" do 
    expect([1,2,2].sequence).to eq([])
  end
end
