module Pik

  class  Devkit < Command
    
    it "Configures devkit settings"

    def execute
      if @args.include? 'update'
        puts "Updating devkit batch files for:"
        config.each{|ruby_version, ruby_config|
             ver = Pik::VersionParser.parse(ruby_version)
             if ver.platform =~ /mingw/
               puts "   #{ver.full_version}"
               write_batch_files(ruby_config[:path])
             end
            config.global[:devkit]
          }
      else
        help
      end
    end
  
    def write_batch_files(path)
      write_make(path)
      write_sh(path)
      write_gcc(path)
    end
    
    def write_make(path)
      BatchFile.new(path + 'make.bat') do |b|
        b.file_data << 'setlocal'
        b.set(:DEVKIT => config.global[:devkit])
        b.set(:PATH => "%DEVKIT%\\gcc\\3.4.5\\bin;%DEVKIT%\\msys\\1.0.11\\bin")
        b.file_data << "bash.exe --login -i -c \"make %*\""
        b.write
      end
    end
    
    def write_sh(path)
      BatchFile.new(path + 'sh.bat') do |b|
        b.file_data << 'setlocal'
        b.set(:DEVKIT => config.global[:devkit])
        b.set(:PATH => "%DEVKIT%\\gcc\\3.4.5\\bin;%DEVKIT%\\msys\\1.0.11\\bin")
        b.file_data << "bash.exe --login -i -c \"sh %*\""
        b.write
      end
    end
    
    def write_gcc(path)
      BatchFile.new(path + 'gcc.bat') do |b|
        b.file_data << 'setlocal'
        b.set(:DEVKIT => config.global[:devkit])
        b.set(:PATH => "%DEVKIT%\\gcc\\3.4.5\\bin;%PATH%")
        b.file_data << "gcc.exe %*"
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

