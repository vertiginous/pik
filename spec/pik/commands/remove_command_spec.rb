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
  
  it "should have a 'quiet' option" do
    cmd = Pik::Remove.new(['--quiet'])
    cmd.quiet.should be_true
    
    cmd = Pik::Remove.new(['-q'])
    cmd.quiet.should be_true
  end
  
  it "should remove items from the config" do
    cmd = Pik::Remove.new(['a', '-f', '-q'], { 
                                   'a' => {:path => 'C:/ruby/bin', :gem_home => 'C:/users/rupert/.gems'}, 
                                   'b' => {:path => 'C:/Ruby19/bin'}
                                   }
    )
    cmd.execute
    cmd.config.should == ( {'b' => {:path => 'C:/Ruby19/bin'}} )
  end
  
end