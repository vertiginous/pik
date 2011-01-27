module Pik

  class  Remove < Command
  
    aka :rm
    it "Removes a ruby location from pik."
    include ConfigFileEditor
    
    attr_reader :force, :quiet
    
    def execute
      to_remove = config.match(@args.first)
      raise QuitError unless to_remove
      
      name, data = *to_remove

      if remove?(name)
        config.delete(name)
        hl.say("#{VersionPattern.full(name)} removed.")
      end
    end
    
    def remove?(name)
      msg = "Are you sure you'd like to remove '#{VersionPattern.full(name)}'?"
      force || hl.agree(msg){|answer| answer.default = 'yes' }
    end

    def command_options
      super
      options.on("--force", "-f", "Remove without prompting") do |value|
        @force = value
      end
    end
    
  end
  
end
