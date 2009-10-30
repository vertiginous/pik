module Pik

  module BatchFileEditor
    
    attr_reader :batch
        
    def initialize(args=ARGV,config=nil)
      super
      batch_file = File.join(PIK_HOME, "#{File.basename($0)}_#{$$}.bat")
      @batch = BatchFile.new( batch_file )
      editors << @batch
    end
    
    def close
      update_gem_batch
      super
    end

    def set(items)
      items.each do |k, v|
        @batch.set(k => v)
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
      
      @batch.set('PATH' => new_path.join )
    end
    
    def switch_gem_home_to(gem_home)
      gem_home = Pathname(gem_home).to_windows rescue nil
      @batch.set('GEM_PATH' => gem_home )
      @batch.set('GEM_HOME' => gem_home )
    end
  
    def echo_ruby_version(path, verb='')
      rb = Which::Ruby.exe(path).basename
      @batch.file_data << "for /f \"delims=\" %%a in ('#{rb} -v') do @echo #{verb} %%a "
    end
  
    def echo_running_with_ruby_version(path)
      echo_ruby_version('Running with')
    end 
    
    def update_gem_batch
      BatchFile.open(PIK_BATCH) do |gem_bat|
        # call new .pik/pik batch
        gem_bat.call(%Q("#{@batch.path.to_windows}")) if @batch
        gem_bat.write        
      end
    end
  
  end
  
end