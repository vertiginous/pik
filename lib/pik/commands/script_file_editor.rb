module Pik

  module ScriptFileEditor
    
    attr_reader :script
        
    def initialize(args=ARGV,config=nil)
      super
      @script = SCRIPT_FILE
      editors << @script
    end

    def set(items)
      items.each do |k, v|
        @script.set(k => v)
        WindowsEnv.user.set(k => v) if global
      end
    end  
      
    def switch_path_to(other)
      current = Which::Ruby.find
      
      new_path = SearchPath.new(ENV['PATH'])
      new_path.replace_or_add(current, other[:path])
      
      # if there is currently a GEM_HOME, remove it's bin dir from the path
      new_path.remove(Pathname.new(ENV['GEM_HOME']) + 'bin') if ENV['GEM_HOME']
      
      # if the new version has a GEM_HOME, add it's bin dir to the path
      new_path.add(Pathname.new(other[:gem_home]) + 'bin') if other[:gem_home]
      
      @script.set('PATH' => new_path.join )
    end
    
    def switch_gem_home_to(gem_home)
      gem_home = Pathname(gem_home).to_windows rescue nil
      @script.set('GEM_PATH' => gem_home )
      @script.set('GEM_HOME' => gem_home )
    end
  
    def echo_ruby_version(path, verb='')
      rb = Which::Ruby.exe(path).basename
      @script.call "#{rb} -v"
    end
   
  end
  
end