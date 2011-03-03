
module Pik

  class  UnInstall < Command
   
    aka :unin
    it "Deletes a ruby version from the filesystem and removes it from Pik."
    
    attr_reader :force
    
    def execute
      to_remove = config.match(@args.first)
      rm_name, rm_config = to_remove
      unless to_remove
        puts "Couldn't find the version you're looking for '#{@args.join(' ')}'."
        raise QuitError
      end
      if force || hl.agree("Are you sure you'd like to uninstall '#{rm_name}'?"){|answer| answer.default = 'yes' }
        Log.info "Deleting #{rm_config[:path].dirname}"
        path = rm_config[:path].dirname
        FileUtils.rm_rf(path) if path.exist?
        remove(rm_name)
        puts
        Log.info "#{rm_name} has been uninstalled."
      end
    end
    
    def remove(to_remove)
      config.options[:remove] = to_remove
      rm = Pik::Remove.new(['--force'], config)
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