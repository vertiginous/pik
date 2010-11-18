
module Pik
  
  class System < Command
  
    it "Switches back to the default settings."
  
    attr_accessor :verbose
  
    include ScriptFileEditor
  
    def execute
      sys = WindowsEnv.system
      usr = WindowsEnv.user
      new_path = [sys['PATH'],usr['PATH']].compact.join(';')
      env['PATH'] = SearchPath.new(new_path)
      env['GEM_PATH'] = usr['GEM_PATH'] || sys['GEM_PATH']
      env['BUNDLE_PATH'] = usr['BUNDLE_PATH'] || sys['BUNDLE_PATH']
      env['GEM_HOME'] = usr['GEM_HOME'] || sys['GEM_HOME']
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
