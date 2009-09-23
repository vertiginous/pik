describe Pik::GemSync do
  it "should have a summary" do
    summary = "Duplicates gems from the current version to the one specified."
    Pik::GemSync.summary.should eql(summary)
  end
  
  describe "gem_install" do
    it "should install gems via batch file" do
      gemsync = Pik::GemSync.new([])
      gemsync.gem_install(Pathname.new('c:/fake/file.gem'))
      gemsync.batch.file_data.should include( "ECHO Installing file.gem" )
      gemsync.batch.file_data.should include( "CALL gem install -q --no-rdoc --no-ri c:/fake/file.gem\n" )
    end
  end
end