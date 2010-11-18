describe Pik::List do

  before do
    @cmd = 'tools\\pik.bat'
    Pik::Commands.clear
    Pik::Commands.add(Pik::List)
    #Pik::ConfigFile.stub!(:new).and_return({})
  end

  describe 'execute' do
    
    # it "should have an alias of ls" do
    #   Pik::List.names.should include(:ls)
    # end
    
    # it "should have a verbose options" do
    #   @ls = Pik::List.new(['-v'])
    #   @ls.verbose.should be_true
    # end
    
  end
  
end