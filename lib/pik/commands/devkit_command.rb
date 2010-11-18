module Pik

  class  Devkit < Command
    
    it "Configures devkit settings"

    def execute
      if @args.include? 'update'
        versions = config.map{|ruby_version, ruby_config| ruby_config if ruby_config[:version] =~ /mingw/ }.compact
        write_batch_files(versions)
      else
        help
      end
    end

    def write_batch_files(versions)
      log.info "Adding devkit batch files for:"
      versions.each{|cfg|
        puts "      #{cfg[:version]}"
        path = cfg[:path]
        write_make(path)
        write_sh(path)
        write_gcc(path)
      }
    end
    
    def write_make(path)
      Pik::BatchFile.new(path + 'make') do |b|
        b.lines << 'setlocal'
        b.set(:DEVKIT => config.global[:devkit])
        b.set(:PATH => "%DEVKIT%\\gcc\\3.4.5\\bin;%DEVKIT%\\msys\\1.0.11\\bin")
        b.lines << "bash.exe --login -i -c \"make %*\""
        b.write
      end
    end
    
    def write_sh(path)
      Pik::BatchFile.new(path + 'sh') do |b|
        b.lines << 'setlocal'
        b.set(:DEVKIT => config.global[:devkit])
        b.set(:PATH => "%DEVKIT%\\gcc\\3.4.5\\bin;%DEVKIT%\\msys\\1.0.11\\bin")
        b.lines << "bash.exe --login -i -c \"sh %*\""
        b.write
      end
    end
    
    def write_gcc(path)
      Pik::BatchFile.new(path + 'gcc') do |b|
        b.lines << 'setlocal'
        b.set(:DEVKIT => config.global[:devkit])
        b.set(:PATH => "%DEVKIT%\\gcc\\3.4.5\\bin;%PATH%")
        b.lines << "gcc.exe %*"
        b.write
      end
    end
  
    def command_options
      super
      sep =<<SEP
SEP
      options.separator sep  
    end
    
  end 
  
end

