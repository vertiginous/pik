module Pik

  module ScriptFileEditor
    
    attr_reader :script
        
    def initialize(args=ARGV,config=nil,log=Log.new)
      super
      @script = SCRIPT_FILE
      @env    = @script
      editors << @script
    end

    def echo_ruby_version(path, verb='')
      rb = Which::Ruby.exe(path).basename
      script.call "#{rb} -v"
    end
   
  end
  
end