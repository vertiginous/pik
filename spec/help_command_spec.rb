
describe Pik::Help do

  before do
    @cmd = 'tools\\pik.bat'
  end

  it "should have a summary" do
    Pik::Help.summary.should eql("Displays help information.")
  end
  
  it "should display when no commands are given" do
    cmd = `#{@cmd}`
    msg = ["Usage: pik command [options]", 
    "To get help with a command",
    "  pik help (command)",
    "To list all commands and descriptions:",
    "  pik help commands"].join("\n\n")
    
    cmd.should include(msg)
  end
  
  it "should display all commands when 'help commands' is given " do
    cmd = `#{@cmd} help commands`
    
    cmd.should include("  help            Displays help information.")
    cmd.should include("For help on a particular command, use 'pik help COMMAND'")
  end
  
end