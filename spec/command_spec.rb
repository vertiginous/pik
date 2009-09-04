describe Pik::Command do

  before(:each) do
    @cmd = Pik::Command.new([])
  end  

  describe "get_version" do
    it "should create a version string" do
      ver = `ruby -v`.chomp
      
      cmd_ver = @cmd.get_version
      cmd_ver.should include(ver)
    
      ver =~ /ruby (\d)\.(\d)\.(\d)/
      ver = $1 + $2 + $3
      cmd_ver.should match(/^#{ver}:/)
    end
  end
  
  describe "current_version?" do
    it "should match the current version" do
      ver = @cmd.get_version
      @cmd.current_version?(ver.chomp).should be_true
    end
  end
  
  describe "current_ruby_bin_path" do
    it "should be a Pathname" do
      @cmd.current_ruby_bin_path.should be_a(Pathname)
      @cmd.current_ruby_bin_path.basename.to_s.should == "bin"
    end
  end
  
end