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
      options.on("--global", "-g", "Make changes globally") do |value|
        @global = value
      end
      
      options.on("-m name", "specify gem_home (Named gem sets)") do |value|
        @gem_home = value
      end
    end
  end
  
end