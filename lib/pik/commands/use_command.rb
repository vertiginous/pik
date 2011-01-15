module Pik

  class  Use < Command
   
    aka :switch, :sw
    it "Switches ruby versions based on patterns."
    include ScriptFileEditor
    include ConfigFileEditor
    
    attr_accessor :gem_home
    attr_accessor :verbose
    
    def execute
      abort('Nothing matches:') unless new_ver = self.class.choose_from(@args, @config)
      config.global[:default] = new_ver
      switch_path_to(@config[new_ver])
      switch_gem_home_to(@config[new_ver][:gem_home])
      echo_ruby_version(@config[new_ver][:path]) if verbose
    end
    
    def command_options
      super
      
      options.on("--verbose", "-v",
         "Display verbose output"
         ) do |value|
        @verbose = true
      end

      options.on("--default",
         "Set the default interpreter"
         ) do |value|
        @default = true
      end


      sep =<<SEP
  Examples:

    C:\\>pik sw 186 mingw
    Using ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]
    
    C:\\>pik switch 191 p1
    Using ruby 1.9.1p129 (2009-05-12 revision 23412) [i386-mingw32]
    
    C:\\>pik use 186 mswin
    Using ruby 1.8.6 (2008-08-11 patchlevel 287) [i386-mswin32]
    
    C:\\>pik 191 p2
    Using ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]
SEP
      options.separator sep
    end
  end

  
end