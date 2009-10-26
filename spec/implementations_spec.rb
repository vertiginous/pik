describe Pik::Implementations do

  describe 'ruby' do
    it 'should return a Implementations::Ruby object' do
      Pik::Implementations.ruby.should be_an(Pik::Implementations::Ruby)
    end
  end
  
  describe 'jruby' do
    it 'should return a Implementations::JRuby object' do
      Pik::Implementations.jruby.should be_an(Pik::Implementations::JRuby)
    end
  end
  
  describe 'ironruby' do
    it 'should return a Implementations::IronRuby object' do
      Pik::Implementations.ironruby.should be_an(Pik::Implementations::IronRuby)
    end
  end
  
  describe '[]' do
    it 'should return the given implementation object.' do
      Pik::Implementations['ironruby'].should be_an(Pik::Implementations::IronRuby)      
    end
    
    it "should raise an exception if the implementation isn't recognized" do
      err = lambda { Pik::Implementations['unicornruby'] }
      err.should raise_error(StandardError, "The implementation 'unicornruby' wasn't found")
    end
  end

  describe 'list' do
  
    it "should return a hash with containing each implemnatation's version hash" do 
      list = Pik::Implementations.list
      list.should be_a(Hash)
      list.should include('Ruby')
      list.should include('JRuby')
      list.should include('IronRuby')
    end
    
  end
end


describe Pik::Implementations::Ruby do
   before(:each) do
   	 # ruby
   	 ruby = mock('URI')
     URI.should_receive(:parse).with('http://rubyforge.org/frs/?group_id=167').any_number_of_times.and_return(ruby)
     @ruby_htm = File.read('spec/html/ruby.htm')
     ruby.should_receive(:read).any_number_of_times.and_return(@ruby_htm)
     
     @ruby = Pik::Implementations::Ruby.new  
   end

   describe 'read' do
    
    it "should return HTML from the Implementation's page" do
       @ruby.read.should == @ruby_htm 
    end

   end
   
   describe 'versions' do
   
     it "should return a hash contain each package" do
       versions = @ruby.versions
       versions.should be_a(Hash)
       versions.should include('1.8.6-p383-i386-mingw32')
       versions.should include('1.9.1-p243-i386-mingw32')
     end
  
  end

	describe 'find' do
  
    it 'should find the most recent version if no argument is given' do
      v = '1.9.1-p243-i386-mingw32'
      u = "http://rubyforge.org/frs/download.php/62269/ruby-1.9.1-p243-i386-mingw32.7z"
      @ruby.find.should eql( [v, u] )
    end
    
    it 'should find a specific version if arguments are given' do
      v = '1.8.6-p383-i386-mingw32'
      u = "http://rubyforge.org/frs/download.php/62267/ruby-1.8.6-p383-i386-mingw32.7z"
      @ruby.find('1.8').should eql( [v, u] )
    end
	
  end

end

describe Pik::Implementations::JRuby do
   before(:each) do
     # jruby
     jruby = mock('URI')
     URI.should_receive(:parse).with("http://www.jruby.org/download").any_number_of_times.and_return(jruby)
     @jruby_htm = File.read('spec/html/jruby.htm')
     jruby.should_receive(:read).any_number_of_times.and_return(@jruby_htm)
     
     @jruby = Pik::Implementations::JRuby.new  
   end

   describe 'read' do
    
    it "should return HTML from the Implementation's page" do
       @jruby.read.should == @jruby_htm 
    end

   end
   
   describe 'versions' do
   
     it "should return a hash contain each package" do
       versions = @jruby.versions
       versions.should be_a(Hash)
       versions.should include('1.3.0')
       versions.should include('1.4.0RC2')
       versions['1.4.0RC2'].should eql( "http://jruby.kenai.com/downloads/1.4.0RC2/jruby-bin-1.4.0RC2.zip" )
     end
  
  end
  
end

describe Pik::Implementations::IronRuby do
   before(:each) do
     # ironruby
     ironruby = mock('URI')
     URI.should_receive(:parse).with('http://rubyforge.org/frs/?group_id=4359').any_number_of_times.and_return(ironruby)
     @ironruby_htm = File.read('spec/html/ironruby.htm')
     ironruby.should_receive(:read).any_number_of_times.and_return(@ironruby_htm)
     
     @ironruby = Pik::Implementations::IronRuby.new  
   end

   describe 'read' do
    
    it "should return HTML from the Implementation's page" do
       @ironruby.read.should == @ironruby_htm 
    end

   end
   
   describe 'versions' do
   
     it "should return a hash contain each package" do
       versions = @ironruby.versions
       versions.should be_a(Hash)
       versions.should include('0.3.0')
       versions.should include('0.9.1')
     end
  
  end
  
end