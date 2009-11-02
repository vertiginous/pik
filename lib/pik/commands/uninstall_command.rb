
module Pik

  class  UnInstall < Command
   
    aka :unin
    it "Deletes a ruby version from the filesystem and removes it from Pik."
    
    attr_reader :force
    
    def execute
      to_remove = self.class.choose_from(@args, @config)
      raise QuitError unless to_remove
      if force || @hl.agree("Are you sure you'd like to uninstall '#{to_remove}'? [Yn] ")  
        puts "** Deleting #{config[to_remove][:path].dirname}"
        path = config[to_remove][:path].dirname
        FileUtils.rm_rf(path) if path.exist?
        remove
        puts
        @hl.say("#{to_remove} has been uninstalled.")
      end
    end
    
    def remove
      rm = Pik::Remove.new(@args + ['--force', '--quiet'], config)
      rm.execute
      rm.close
    end
    
    def command_options
      super
      options.on("--force", "-f", "Remove without prompting") do |value|
        @force = value
      end
    end
  
  end
    
end