
module Pik
  
  class Implode < Command
  
    it "Removes your pik configuration."
  
    attr_reader :force
  
    def execute
      msg =  "Are you sure you want pik to implode? "
      msg << "This will remove '#{PIK_HOME.to_ruby}'. [Yn] "
      if @force || @hl.agree(msg)
        PIK_HOME.rmtree
      end
    end
    
    def command_options
      super  
      options.on("--force", "-f", "Force") do |value|
        @force = value
      end 
    end 
  
  end

end