
module Pik
  
  class Implode < Command
  
    it "Removes your pik configuration."
  
    def execute
      if @hl.agree("Are you sure you want pik to implode? This will remove '#{PIK_HOME.to_ruby}'. [Yn] ") 
        PIK_HOME.rmtree
      end
    end
  
  end

end