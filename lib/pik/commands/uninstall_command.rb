
module Pik

  class  UnInstall < Command
   
    aka :unin
    it "Deletes a ruby version from the filesystem and removes it from Pik."
    
    attr_reader :force
    
    def execute
      to_remove = @config.match(@args.first)
      unless to_remove
        puts "Couldn't find the version you're looking for '#{@args.join(' ')}'."
        raise QuitError
      end
      if force || @hl.agree("Are you sure you'd like to uninstall '#{to_remove}'?"){|answer| answer.default = 'yes' }
        puts "** Deleting #{config[to_remove][:path].dirname}"
        path = config[to_remove][:path].dirname
        FileUtils.rm_rf(path) if path.exist?
        remove(to_remove)
        puts
        @hl.say("#{to_remove} has been uninstalled.")
      end
    end
    
    def remove(to_remove)
      rm = Pik::Remove.new([to_remove, '--force', '--quiet'], config)
      rm.execute
      rm.close
    end
    
    def command_options
      super
      options.on("--force", "-f", "Uninstall without prompting") do |value|
        @force = value
      end
    end
  
  end
    
end