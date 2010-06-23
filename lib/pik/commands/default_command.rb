
module Pik
  
  class Default < Command
  
    it "Switches back to the default settings."
  
    attr_accessor :verbose
  
    include ScriptFileEditor
  
    def execute
      sys = WindowsEnv.system
      usr = WindowsEnv.user
      new_path = [sys['PATH'],usr['PATH']].compact.join(';')
      @script.set('PATH' => SearchPath.new(new_path) )
      @script.set('GEM_PATH' => usr['GEM_PATH'] || sys['GEM_PATH'] )
      @script.set('GEM_HOME' => usr['GEM_HOME'] || sys['GEM_HOME'] )
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
