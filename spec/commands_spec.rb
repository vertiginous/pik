module Pik
  class Spec < Command
    it  'is a command called spec'
    aka :sp
  end
end

describe Pik::Commands do
 
  before do
    Pik::Commands.clear
    Pik::Commands.add(Pik::Spec)
  end
  
  describe 'description' do
    it 'should list all commands' do
      msg=<<-MSG
  spec|sp         is a command called spec

For help on a particular command, use 'pik help COMMAND'.
MSG
      Pik::Commands.description.should eql(msg.chomp)
    end
  end
  
  describe 'find' do
    it 'should find a command class' do 
      Pik::Commands.find(:spec).should eql(Pik::Spec)
    end
    
    it "should return nil if the command doesn't exist" do
      Pik::Commands.find(:nil).should be_nil
    end
    
  end
  
  describe "list" do
    it "should return an array of command names as symbols" do
      Pik::Commands.list.should eql([:spec, :sp])
    end
  end


end