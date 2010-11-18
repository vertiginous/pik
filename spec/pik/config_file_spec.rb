
describe Pik::ConfigFile do

  before do
    cfg = {"jruby-1.5.1"=>
      {:version=>
        "jruby 1.5.1 (ruby 1.8.7 patchlevel 249) (2010-06-06 f3a3480) (Java HotSpot(TM) Client VM 1.6.0_20) [x86-java]",
       :path=>Pathname('C:/Users/gthiesfeld/.pik/rubies/jruby-1.5.1/bin')},
     "ruby-1.8.6-p398"=>
      {:version=>"ruby 1.8.6 (2010-02-04 patchlevel 398) [i386-mingw32]",
       :path=>Pathname('C:/bin/rubies/ruby-186-p398/bin')},
     "ruby-1.8.7-p249"=>
      {:version=>"ruby 1.8.7 (2010-01-10 patchlevel 249) [i386-mingw32]",
       :path=>Pathname('C:/Users/gthiesfeld/.pik/rubies/ruby-1.8.7-p249-1/bin')},
     "ruby-1.9.1-p378"=>
      {:version=>"ruby 1.9.1p378 (2010-01-10 revision 26273) [i386-mingw32]",
       :path=>Pathname('C:/Users/gthiesfeld/.pik/rubies/ruby-1.9.1-p378-1/bin')},
     "ironruby-0.9.2"=>
      {:version=>"IronRuby 0.9.2.0 on .NET 2.0.0.0",
       :path=>Pathname('C:/bin/rubies/IronRuby-092/bin')},
     "jruby-1.4.1"=>
      {:version=>
        "jruby 1.4.1 (ruby 1.8.7 patchlevel 174) (2010-04-26 ea6db6a) (Java HotSpot(TM) Client VM 1.6.0_18) [x86-java]",
       :path=>Pathname('C:/bin/rubies/JRuby-141/bin')},
     "ruby-1.9.2-dev"=>
      {:version=>"ruby 1.9.2dev (2010-05-31) [i386-mingw32]",
       :path=>Pathname('C:/bin/rubies/Ruby-192dev-preview3-1/bin'),
       :default=>true
       }}
    @cfg = Pik::ConfigFile.new('')
    @cfg.merge! cfg
  end

  describe "#inserting" do
    it "should insert into the config" do
      ironruby = @cfg["ironruby-1.0.0.0"] = {}
      ironruby[:version] = "IronRuby 1.0.0.0 on .NET 4.0.30319.1"
      ironruby[:path]    = Pathname('C:/Users/gthiesfeld/.pik/rubies/ironruby-1.0v4/bin')

      @cfg["ironruby-1.0.0.0"][:version].should == "IronRuby 1.0.0.0 on .NET 4.0.30319.1"
      @cfg["ironruby-1.0.0.0"][:path].should == Pathname('C:/Users/gthiesfeld/.pik/rubies/ironruby-1.0v4/bin')
    end
  end

  describe "#find_default" do
    it "should return the key of the default version" do
      @cfg.default.should == "ruby-1.9.2-dev"
    end
  end

  describe "#set_default" do
    it "should return the key of the default version" do
      @cfg.default = 'jruby-1.4.1'
      @cfg.default.should == 'jruby-1.4.1'
    end
  end

  describe "#matches" do
    it "should return the key of the matching versions" do
      match = @cfg.matches('jruby-1.4.1')
      match.should == ['jruby-1.4.1']
    end

    it "should return all matching versions of a selector" do
      match = @cfg.matches('jruby')
      match.should == ["jruby-1.5.1", "jruby-1.4.1"]
    end

    it "should not match incomplete versions" do
      match = @cfg.matches('1.8')
      match.should == []
    end

    it "should match complete versions" do
      match = @cfg.matches('1.8.7')
      match.should == ["ruby-1.8.7-p249"]
    end
  end
end
