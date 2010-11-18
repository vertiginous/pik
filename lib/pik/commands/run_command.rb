module Pik

  class  Run < Command
  	
  	it "Runs command with all versions of ruby that pik is aware of."

    def execute
      check_args
      list = list?(args.first) ? build_args : config
      list.each do |new_ver, cfg|
        begin
          gem_home = gemset_gem_home(new_ver, nil)
          FileUtils.mkdir_p gem_home
          global = gemset_global(new_ver)
          FileUtils.mkdir_p global

          gem_path = SearchPath.new(global).add(gem_home)
          
          switch_gem_home_to(gem_home)
          switch_bundle_path_to(gem_home)
          switch_gem_path_to(gem_path)
          switch_path_to(cfg[:path],gem_path)
          echo_ruby_version(cfg[:path])

          system command
          puts
        rescue => e
          log.error e, e.backtrace
        end
      end
    end
    
    def command(cmd='CALL')
      args = @args.map{|a| a.sub(/.*\s.*/m, '"\&"')}.join(' ')
      "#{cmd} #{args}"
    end
    
    
    def command_options
      super
      options.separator help_message  
    end
    
    def help_message
      sep =<<SEP
  Examples:

    C:\\>pik run PATH

    C:\\>pik run rake spec

SEP
    end

    def parse_options
    end

    def echo_ruby_version(path)
      rb = Which::Ruby.exe(path)
      raise "Unable to find a Ruby executable at #{path}" unless rb
      puts `"#{rb}" -v `
      puts
    end
    
    def check_args
      if args_required? && @args.empty?
        raise "The #{cmd_name} command must be called with an argument"
      end
    end
    
    def args_required?
      true
    end

    def build_args
      h = {}
      args.shift.split(',').each do |imp|
        ver = self.class.choose_from(imp, config.keys).first
        h[ver] = config[ver]
      end
      h
    end

    def list?(str)
      str =~ /.+,.+/
    end

  end

  class Ruby < Run
  
    aka :rb
    it "Runs ruby with all versions that pik is aware of."
    
    def command(cmd=Which::Ruby.exe.basename)
      super(cmd)
    end

    def help_message
      sep =<<SEP
  Examples:

    C:\\>pik ruby -v

    C:\\>pik rb -e "puts 'Hello world!'"

SEP
    end
    
  end
  
  class Gem < Run
  
    it "Runs the gem command with all versions that pik is aware of."
    
    def command(cmd=Which::Gem.bat.basename)
      super(cmd)
    end
    
    def help_message
      sep =<<SEP
  Examples:

    C:\\>pik gem list

    C:\\>pik gem install my_gem

SEP
    end
    
  end

  class Rake < Run
  
    it "Runs the rake command with all versions that pik is aware of."
    
    def command(cmd=Which::Rake.bat.basename)
      super(cmd)
    end
    
    def help_message
      sep =<<SEP
  Examples:

    C:\\>pik rake spec

SEP
    end
    
    def args_required?
      false
    end
    
  end
  
  class Benchmark < Ruby
    
    it "Bencmarks the given script with all versions that pik is aware of."
    aka :bench
    
    def execute
            abort self.class.description if @args.empty?
      file_name = @args.first
      file_data = File.read(file_name)
        
      Tempfile.open('pik_bench') do |temp|
        @args = [temp.path]
        temp.write benchmark(file_name, file_data)
      end
      super
    end   
  
    def benchmark(name, data)
    bench =<<BM
require "benchmark" 
Benchmark.bmbm do |benchmark| 
  benchmark.report("** benchmarking '#{File.basename(name)}'") do 
    #{data}
  end
end
BM
    end
    
    def help_message
      sep =<<SEP
  Examples:

    C:\\>pik benchmark hello.rb

SEP
    end
    
  end

end

