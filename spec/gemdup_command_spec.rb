describe Pik::GemDup do
  it "should have a summary" do
    Pik::GemDup.summary.should eql("Duplicates gems from one Ruby version to another.")
  end
  
  describe "gem_install" do
    it "should install gems via batch file" do
      gemdup = Pik::GemDup.new([])
      gemdup.gem_install(Pathname.new('c:/fake/file.gem'))
      gemdup.batch.file_data.should include( "ECHO Installing file.gem" )
      gemdup.batch.file_data.should include( "CALL gem install -q --no-rdoc --no-ri c:/fake/file.gem\n" )
    end
  end
end