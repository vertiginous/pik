module Pik

  class Update < Command
   
    aka :up
    it "updates pik."
    include BatchFileEditor
    
    def execute
      default
      results = `#{Which::Gem.exe} update pik`
      puts results
      update_re = /Nothing to update/
      @batch.call("pik_install #{PIK_BATCH.dirname}") unless results.match(update_re)
    end
    
    def default
      # should move to default implementation before attemping an update
    end
     
  end

end