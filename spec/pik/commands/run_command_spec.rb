
describe Pik::Run do

  it "should have a summary" do
    Pik::Run.summary.should eql("Executes shell command with all versions of ruby that pik is aware of.")
  end
  
end