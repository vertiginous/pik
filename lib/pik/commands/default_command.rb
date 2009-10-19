
module Pik
  
  class Default < Command
  
    it "Switches back to the default settings."
  
    attr_accessor :verbose
  
    include BatchFileEditor
  
    def execute
      unless User.new.admin?
        raise "You must have admin rights for the default command"
      end
      sys = WindowsEnv.system
      usr = WindowsEnv.user
      new_path = [sys['PATH'],usr['PATH']].compact.join(';')
      @batch.set('PATH' => new_path )
      @batch.set('GEM_PATH' => usr['GEM_PATH'] || sys['GEM_PATH'] )
      @batch.set('GEM_HOME' => usr['GEM_HOME'] || sys['GEM_HOME'] )
      echo_ruby_version(Which::Ruby.find(new_path)) if verbose
    end
    
    def command_options
      super
      @options.on("--verbose", "-v",
         "Verbose output"
         ) do |value|
        @verbose = value
      end
    end
  
  end

end
