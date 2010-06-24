  describe Pik::VersionParser do

  {
  "091: IronRuby 0.9.1.0 on .NET 2.0.0.0" => OpenStruct.new(
     :interpreter  => "IronRuby",
     :version      => "0.9.1.0",
     :date         => nil,
     :platform     => ".NET 2.0.0.0",
     :patchlevel   => nil,
     :full_version => "IronRuby 0.9.1.0 on .NET 2.0.0.0",
     :short_version => 'ironruby-0.9.1.0'
    ), 
  "092: IronRuby 0.9.2.0 on .NET 2.0.0.0" => OpenStruct.new(
     :interpreter  => "IronRuby",
     :version      => "0.9.2.0",
     :date         => nil,
     :platform     => ".NET 2.0.0.0",
     :patchlevel   => nil,
     :full_version => "IronRuby 0.9.2.0 on .NET 2.0.0.0",
     :short_version => 'ironruby-0.9.2.0'
    ), 
  "131: jruby 1.3.1 (ruby 1.8.6p287) (2009-06-15 2fd6c3d) (Java HotSpot(TM) Client VM 1.6.0_14) [x86-java]" => OpenStruct.new(
     :interpreter  => "jruby",
     :version      => "1.3.1",
     :date         => "2009-06-15",
     :platform     => "x86-java",
     :patchlevel   => nil,
     :full_version => "jruby 1.3.1 (ruby 1.8.6p287) (2009-06-15 2fd6c3d) (Java HotSpot(TM) Client VM 1.6.0_14) [x86-java]",
     :short_version => 'jruby-1.3.1'
    ), 
  "140: jruby 1.4.0 (ruby 1.8.7 patchlevel 174) (2009-11-02 69fbfa3) (Java HotSpot(TM) Client VM 1.6.0_14) [x86-java]" => OpenStruct.new(
     :interpreter  => "jruby",
     :version      => "1.4.0",
     :date         => "2009-11-02",
     :platform     => "x86-java",
     :patchlevel   => nil,
     :full_version => "jruby 1.4.0 (ruby 1.8.7 patchlevel 174) (2009-11-02 69fbfa3) (Java HotSpot(TM) Client VM 1.6.0_14) [x86-java]",
     :short_version => 'jruby-1.4.0'
    ), 
  "185: ruby 1.8.5 (2006-12-25 patchlevel 12) [i386-mswin32]" => OpenStruct.new(
     :interpreter  => "ruby",
     :version      => "1.8.5",
     :date         => "2006-12-25",
     :platform     => "i386-mswin32",
     :patchlevel   => "12",
     :full_version => "ruby 1.8.5 (2006-12-25 patchlevel 12) [i386-mswin32]",
     :short_version => 'ruby-1.8.5-p12'
    ), 
  "186: ruby 1.8.6 (2008-08-11 patchlevel 287) [i386-mswin32]" => OpenStruct.new(
     :interpreter  => "ruby",
     :version      => "1.8.6",
     :date         => "2008-08-11",
     :platform     => "i386-mswin32",
     :patchlevel   => "287",
     :full_version => "ruby 1.8.6 (2008-08-11 patchlevel 287) [i386-mswin32]",
     :short_version => 'ruby-1.8.6-p287'
    ), 
  "186: ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]" => OpenStruct.new(
     :interpreter  => "ruby",
     :version      => "1.8.6",
     :date         => "2009-03-31",
     :platform     => "i386-mingw32",
     :patchlevel   => "368",
     :full_version => "ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]",
     :short_version => 'ruby-1.8.6-p368'
    ), 
  "186: ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]" => OpenStruct.new(
     :interpreter  => "ruby",
     :version      => "1.8.6",
     :date         => "2009-08-04",
     :platform     => "i386-mingw32",
     :patchlevel   => "383",
     :full_version => "ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]",
     :short_version => 'ruby-1.8.6-p383'
    ), 
  "187: ruby 1.8.7 (2010-01-10 patchlevel 249) [i386-mingw32]" => OpenStruct.new(
     :interpreter  => "ruby",
     :version      => "1.8.7",
     :date         => "2010-01-10",
     :platform     => "i386-mingw32",
     :patchlevel   => "249",
     :full_version => "ruby 1.8.7 (2010-01-10 patchlevel 249) [i386-mingw32]",
     :short_version => 'ruby-1.8.7-p249'
    ),   
    "187-opt: ruby 1.8.7 (2010-01-10 patchlevel 249) [i386-mingw32]" => OpenStruct.new(
     :interpreter  => "ruby",
     :version      => "1.8.7",
     :date         => "2010-01-10",
     :platform     => "i386-mingw32",
     :patchlevel   => "249",
     :full_version => "ruby 1.8.7 (2010-01-10 patchlevel 249) [i386-mingw32]",
     :short_version => 'ruby-1.8.7-p249-opt'
    ), 
  "191: ruby 1.9.1p129 (2009-05-12 revision 23412) [i386-mingw32]" => OpenStruct.new(
     :interpreter  => "ruby",
     :version      => "1.9.1",
     :date         => "2009-05-12",
     :platform     => "i386-mingw32",
     :patchlevel   => "129",
     :full_version => "ruby 1.9.1p129 (2009-05-12 revision 23412) [i386-mingw32]",
     :short_version => 'ruby-1.9.1-p129'
    ), 
  "191: ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]" => OpenStruct.new(
     :interpreter  => "ruby",
     :version      => "1.9.1",
     :date         => "2009-07-16",
     :platform     => "i386-mingw32",
     :patchlevel   => "243",
     :full_version => "ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]",
     :short_version => 'ruby-1.9.1-p243'
    ),
  "191-rc1: ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]" => OpenStruct.new(
     :interpreter  => "ruby",
     :version      => "1.9.1",
     :date         => "2009-07-16",
     :platform     => "i386-mingw32",
     :patchlevel   => "243",
     :full_version => "ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]",
     :short_version => 'ruby-1.9.1-p243-rc1'
    )
  }.each do |string, data| 

    ruby_version = Pik::VersionParser.parse(string)
  
    describe '#parse' do
      it 'should return a VersionParser object' do
        ruby_version.should be_a(Pik::VersionParser)
      end
    end

    it "should have an interpreter for #{string}" do
      ruby_version.interpreter.should eql(data.interpreter)
    end
    
    it "should have a version for #{string}" do
      ruby_version.version.should eql(data.version)
    end
    
    it "should have a date for #{string}" do
      ruby_version.date.should eql(data.date)
    end    

    it "should have a platform for #{string}" do
      ruby_version.platform.should eql(data.platform)
    end
 
     it "should have a patchlevel for #{string}" do
      ruby_version.patchlevel.should eql(data.patchlevel)
    end

    it "should have a full_version for #{string}" do
      ruby_version.full_version.should eql(data.full_version)
    end
 
    it "should have a short_version for #{string}" do
      ruby_version.short_version.should eql(data.short_version)
    end

  end
  
end