module Pik

  class  Remove < Command
  
    aka :rm
    it "Removes a ruby location from pik."
    include ConfigFileEditor
    
    attr_reader :force, :quiet
    
    def execute
      to_remove = self.class.choose_from(@args, @config)
      raise QuitError unless to_remove
      if force || @hl.agree("Are you sure you'd like to remove '#{to_remove}'?"){|answer| answer.default = 'yes' }
        @config.delete(to_remove)
        @hl.say("#{to_remove} removed.") unless quiet
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
