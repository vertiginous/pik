
describe Pathname do

  describe '==' do
    it 'should test for equality' do
      path1 = Pathname('Z:/This/is/to/test/EQUALITY')
      path2 = Pathname('Z:\\this\\is\\to\\test\\equality')
      path1.should == path2
    end
  end
  
  describe 'to_windows' do
    it 'should change the file separator' do
      path   = Pathname('Z:/This/is/to/test/separators')
      result = "Z:\\This\\is\\to\\test\\separators"
      path.to_windows.should eql(result)
      p = "C:\\Doc\\gthiesfeld/.pik/dl/ir.zip"
      Pathname(p).to_windows.should eql("C:\\Doc\\gthiesfeld\\.pik\\dl\\ir.zip")    
    end
  end
  
  describe 'to_ruby' do
    it 'should change the file separator' do
      path   = Pathname("Z:\\This\\is\\to\\test\\separators")
      result = 'Z:/This/is/to/test/separators'
      path.to_ruby.should eql(result)
    end
  end

end