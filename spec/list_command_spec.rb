describe Pik::List do

  before do
    @cmd = 'tools\\pik.bat'
    Pik::Commands.clear
    Pik::Commands.add(Pik::List)
    #Pik::ConfigFile.stub!(:new).and_return({})
  end

  describe 'execute' do
    it "should show config output" do
      cmd = `#{@cmd} list`
      cmd.should match(/186: ruby 1\.8\.6 \(2009\-03\-31 patchlevel 368\)/)
    end
    
    it "should have an alias of ls" do
      Pik::List.names.should include(:ls)
    end
    
    it "should show current ruby version with an '*'" do
      version = `ruby -v`.strip
      cmd = `#{@cmd} list`
      cmd.should match(/#{Regexp.escape(version)} \*/)
    end
    
    it "should have a verbose options" do
      @ls = Pik::List.new(['-v'])
      @ls.verbose.should be_true
    end
    
  end
  
end