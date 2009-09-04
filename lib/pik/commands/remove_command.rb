module Pik

  class  Remove < Command
  
    aka :rm
    it "Removes a ruby location from pik."
    include ConfigFileEditor
    
    attr_reader :quiet
    
    def execute
      to_remove = self.class.choose_from(@args, @config)
      raise QuitError unless to_remove
      if quiet || @hl.agree("Are you sure you'd like to remove '#{to_remove}'? [Yn] ")  
        @config.delete(to_remove)
        @hl.say("#{to_remove} removed") unless quiet
      end
    end
    
    def command_options
      options.on("--quiet", "-q", "Remove without prompting") do |value|
        @quiet = value
      end
    end
    
  end
  
end