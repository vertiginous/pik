module Pik

  class Update < Command
   
    aka :up
    it "updates pik."
    include BatchFileEditor
    
    def execute
      sh "#{Which::Gem.exe} install pik"
      @batch.call("pik_install #{PIK_BATCH.dirname}")
    end
     
  end

end