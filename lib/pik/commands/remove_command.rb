module Pik

  class  Remove < Command
  
    aka :rm
    it "Removes a ruby location from pik."
    include ConfigFileEditor
    
    attr_reader :force, :quiet
    
    def execute
      to_remove = @config.match(@args.first)
      raise QuitError unless to_remove
      
      rm_name, rm_config = *to_remove

      if force || @hl.agree("Are you sure you'd like to remove '#{rm_name}'?"){|answer| answer.default = 'yes' }
        @config.delete(rm_name)
        @hl.say("#{rm_name} removed.") unless quiet
      end
    end
    
    def command_options
      super
      options.on("--force", "-f", "Remove without prompting") do |value|
        @force = value
      end
      options.on("--quiet", "-q", "Remove without a response") do |value|
        @quiet = value
      end
    end
    
  end
  
end
