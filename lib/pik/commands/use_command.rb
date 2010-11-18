module Pik

  class  Use < Command
   
    # aka :switch, :sw
    it "Switches ruby versions based on patterns."
    include ScriptFileEditor
    include ConfigFileEditor
    
    attr_accessor :global
    attr_accessor :gem_home
    attr_accessor :verbose
    attr_accessor :gemset
    attr_accessor :default
  
    def execute
      new_ver = args.first
      cfg = config[new_ver]
      if gemset 
        gem_home = gemset_gem_home(new_ver, gemset)
        log.error GemSetMissingError.new(gemset).message unless gem_home.exist?
      else
        gem_home = gemset_gem_home(new_ver, nil)
        FileUtils.mkdir_p gem_home
      end

      global = gemset_global(new_ver)
      FileUtils.mkdir_p global

      gem_path = SearchPath.new(global).add(gem_home)
      
      switch_gem_home_to(gem_home)
      switch_bundle_path_to(gem_home)
      switch_gem_path_to(gem_path)
      switch_path_to(cfg[:path],gem_path)
      set_default(cfg) if default
      echo_ruby_version(cfg[:path]) if verbose
    end

    def set_default(cfg)
      config['default'] = cfg
    end
    
    def command_options
      super
      
      options.on("--verbose", "-v",
         "Display verbose output"
         ) do |value|
        @verbose = true
      end
      
      options.on("--gemset=gemset",
         "Use gem set"
         ) do |value|
        @gemset = value
      end

      options.on("--default",
         "Sets the default ruby"
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