
module Pik
  
  class Implode < Command
  
    it "removes your pik config"
  
    def execute
      if @hl.agree("Are you sure you want pik to implode? This will remove '#{PIK_HOME.to_ruby}'. [Yn] ") 
        PIK_HOME.rmtree
      end
    end
  
  end

end