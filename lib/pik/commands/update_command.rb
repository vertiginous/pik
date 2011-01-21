module Pik

  class Update < Command
   
    aka :up
    it "updates pik."
    include ScriptFileEditor

    def execute
      sh "#{Which::Gem.exe} install pik"
      @script.call("pik_install #{Pik.exe.dirname}")
    end
     
  end

end