
describe Pik::Run do
  it "should have a summary" do
    Pik::Run.summary.should eql("Runs command with all versions of ruby that pik is aware of.")
  end
  
  it "should use a batch file to switch paths" do
    cmd = Pik::Command.new([],nil)
    current_version = cmd.get_version
    current_path    = Which::Ruby.find
    ENV['PATH']="C:\\Program Files\\Putty;#{Pathname.new(current_path).to_windows}"
    cmd = Pik::Run.new(['rake -V'], {
                                     current_version => {:path => Pathname(current_path)},
                                     'a' => {:path => 'C:/ruby/bin', :gem_home => 'C:/users/rupert/.gems'}, 
                                     'b' => {:path => 'C:/Ruby19/bin'}
                                     }
    )
    cmd.execute
    batch = cmd.instance_variable_get('@batch').file_data
    
    batch[1].should eql("SET PATH=#{ENV['PATH']}")
    batch[2].should eql("SET GEM_PATH=")
    batch[3].should eql("SET GEM_HOME=")
    batch[4].should eql("CALL rake -V\n")
    
    batch[6].should eql("SET PATH=C:\\Program Files\\Putty;C:\\ruby\\bin;C:\\users\\rupert\\.gems\\bin")
    batch[7].should eql("SET GEM_PATH=C:\\users\\rupert\\.gems")
    batch[8].should eql("SET GEM_HOME=C:\\users\\rupert\\.gems")
    batch[9].should eql("CALL rake -V\n")
    
    batch[11].should eql("SET PATH=C:\\Program Files\\Putty;C:\\Ruby19\\bin")
    batch[12].should eql("SET GEM_PATH=")
    batch[13].should eql("SET GEM_HOME=")
    batch[14].should eql("CALL rake -V\n")
  end
end