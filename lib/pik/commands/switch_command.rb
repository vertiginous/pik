module Pik

  class  Switch < Command
   
    aka :sw, :use
    it "Switches to another Ruby version."
    include BatchFileEditor
    
    attr_accessor :global
    attr_accessor :gem_home
    
    def execute
      abort('Nothing matches:') unless new_ver = self.class.choose_from(@args, @config)
      switch_path_to(@config[new_ver])
      switch_gem_home_to(@config[new_ver][:gem_home]) 
      echo_ruby_version
    end
    
    def command_options
      # options.on("--global", "-g", "Make changes globally") do |value|
      #   @global = value
      # end
      
      # options.on("-m name", "specify gem_home (Named gem sets)") do |value|
      #   @gem_home = value
      # end
      sep =<<SEP
Switches ruby versions based on a pattern.
  
    Examples:

      C:\>pik sw 186 mingw
       == Switching to ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32] ==
      
      C:\>pik switch 191 p1
       == Switching to ruby 1.9.1p129 (2009-05-12 revision 23412) [i386-mingw32] ==
      
      C:\>pik use 186 mswin
       == Switching to ruby 1.8.6 (2008-08-11 patchlevel 287) [i386-mswin32] ==
      
      C:\>pik 191 p2
       == Switching to ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32] ==
SEP
      options.separator sep  
    end
  end

  
end