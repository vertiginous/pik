require 'pathname'

describe Pik::Use do
  
  it "should have a summary" do
    Pik::Use.summary.should eql("Switches ruby versions based on patterns.")
  end
  
  it "should have an alias of sw" do
    Pik::Use.names.should include(:sw)
  end
  
  it "should have an alias of use" do
    Pik::Use.names.should include(:use)
  end
  
  it "should have a global option" #do
  #   sw = Pik::Use.new(['-g'])
  #   sw.global.should be_true
  # end

  it "should have a gem_home option" # do
  #   sw = Pik::Use.new(['-m', 'test'])
  #   sw.gem_home.should eql("test")
  # end
  
  it "should use a batch file to switch paths" do
    conf = {
      'spec ' => {:path => Pathname('C:/ruby/bin')},
      'real ' => {:path => Pathname(::RbConfig::CONFIG['bindir'] )}
    }
    cmd = Pik::Use.new(['spec'], conf)
    cmd.execute
    batch = cmd.instance_variable_get('@script').lines
    batch.should include("SET GEM_PATH=")
    batch.should include("SET GEM_HOME=")
    set_path = batch.grep(/set/i).first
    set_path.should match(/SET PATH=.+C\:\\ruby\\bin.+/i)
  end
  
  it "should switch gem_home and gem_path if the config has a :gem_home" do
    conf = {
      'spec ' => {
          :path => Pathname('C:/ruby/bin'), 
          :gem_home => Pathname('C:/Users/martin_blanke/.gems')
        },
      'real ' => {:path => Pathname.new(::RbConfig::CONFIG['bindir'] )}
      }
    cmd = Pik::Use.new(['spec'], conf)
    cmd.execute
    batch = cmd.instance_variable_get('@script').lines
    batch.should include("SET GEM_PATH=C:\\Users\\martin_blanke\\.gems")
    batch.should include("SET GEM_HOME=C:\\Users\\martin_blanke\\.gems")
  end
    
end