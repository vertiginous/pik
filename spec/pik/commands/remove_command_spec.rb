describe Pik::Remove do

  it "should have a summary" do
    Pik::Remove.summary.should eql("Removes a ruby location from pik.")
  end
  
  it "should have a 'force' option" do
    cmd = Pik::Remove.new(['--force'])
    cmd.force.should be_true
    
    cmd = Pik::Remove.new(['-f'])
    cmd.force.should be_true
  end

  it "should remove items from the config" do
    cfg = Pik::ConfigFile.new('')
    cfg.rubies['a'] = {:path => 'C:/ruby/bin' }
    cfg.rubies['b'] = {:path => 'C:/Ruby19/bin'}
    
    cmd = Pik::Remove.new(['a', '-f'], cfg)
    cmd.execute
    cmd.config.should_not include('a')
  end
  
end