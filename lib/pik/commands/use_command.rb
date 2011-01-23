module Pik

  class  Use < Command
   
    it "Switches ruby versions by name."
    
    include ScriptFileEditor
    include ConfigFileEditor
    
    attr_accessor :verbose
    attr_accessor :default
    
    def execute
      new_ver = @config.options.fetch(:use, @config.match(@args.shift))
      abort('Nothing matches:') unless new_ver

      ver_name, ver_config = *new_ver
      
      @config.global[:default] = VersionPattern.full(ver_name) if default
      
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

    C:\\>pik use 1.8.7

    C:\\>ruby -v
    ruby 1.8.7 (2010-12-23 patchlevel 330) [i386-mingw32]

    C:\\>pik 1.9.1

    C:\\>ruby -v
    ruby 1.9.1p430 (2010-08-16 revision 28998) [i386-mingw32]

    C:\\>pik 1.9.2

    C:\\>ruby -v
    ruby 1.9.2p136 (2010-12-25) [i386-mingw32]

    C:\\>pik jruby-1.6.0

    C:\\>jruby -v
    jruby 1.6.0.RC1 (ruby 1.8.7 patchlevel 330) (2011-01-10 769f847) 
    
SEP
      options.separator sep
    end
  end

  
end