
module Pik
  
  class Default < Command
  
    it "switches back to the default settings"
  
    include BatchFileEditor
  
    def execute
      sys = WindowsEnv.system
      usr = WindowsEnv.user
      
      @batch.set('PATH' => sys['PATH'] + ';' + usr['PATH'] )
      @batch.set('GEM_PATH' => usr['GEM_PATH'] || sys['GEM_PATH'] )
      @batch.set('GEM_HOME' => usr['GEM_HOME'] || sys['GEM_HOME'] )
      echo_ruby_version
    end
  
  end

end