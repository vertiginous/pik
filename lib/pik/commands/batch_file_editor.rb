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
      
    def switch_path_to(new_ver)
      dir = current_ruby_bin_path
      current_config = config[ find_config_from_path(dir) ]
      
      new_path = SearchPath.new(ENV['PATH']).replace_or_add(dir, new_ver[:path])
      if new_gem_home = new_ver[:gem_home]
        
        new_gem_bin = Pathname.new(new_gem_home) + 'bin'
        
        if current_gem_home = current_config[:gem_home]
          current_gem_bin = Pathname.new(current_gem_home) + 'bin'
          new_path.replace(current_gem_bin, new_gem_bin)
        else
          new_path.add(new_gem_bin)
        end
      else
        if current_gem_home = current_config[:gem_home]
          current_gem_bin = Pathname.new(current_gem_home) + 'bin'
          new_path.remove(current_gem_bin)
        end
      end
      @batch.set('PATH' => new_path.join )
    end

    def switch_gem_home_to(gem_home_dir)
      gem_home_dir ||= ''
      gem_path = Pathname.new(gem_home_dir).to_windows 
      @batch.set('GEM_PATH' => gem_path )
      @batch.set('GEM_HOME' => gem_path )
    end
  
    def echo_ruby_version(path, verb='')
      rb = ruby_exe(path).basename
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