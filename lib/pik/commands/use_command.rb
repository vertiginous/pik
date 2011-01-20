module Pik

  class  Use < Command
   
    it "Switches ruby versions by name."
    include ScriptFileEditor
    include ConfigFileEditor
    
    attr_accessor :verbose
    attr_accessor :default
    
    def execute
      new_ver = @config.options[:use] || @config.match(@args.shift)
      abort('Nothing matches:') unless new_ver

      ver_name, ver_config = *new_ver
      
      @config.global[:default] = VersionPatter.fulll(ver_name) if default
      
      switch_path_to(ver_config)
      switch_gem_home_to(ver_config[:gem_home])
      
      echo_ruby_version(ver_config[:path]) if verbose
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

    C:\\>pik use 186 mingw
    Using ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]
    
    C:\\>pik use 191 p1
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