
describe Pik::Add do

  it "should have a summary" do
    Pik::Add.summary.should eql("Adds another ruby location to pik.")
  end
  
  it "should have an interactive option" do
    add = Pik::Add.new(['-i'])
    add.interactive.should be_true
  end

end