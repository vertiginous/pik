module Pik

  class  Tags < Command
    
    it 'Runs the pik command against the given tags.'
    
    def execute
      config.global[:tags] ||= Hash.new{|h,k| h[k] = [] }
      @tag_config = ConfigFile.new('')
      abort self.class.description if @args.empty?
      
      tags = @args.shift.split(',')
      tags.each do |tag|
        versions = config.global[:tags][tag]
        raise "Tag '#{tag}' unknown" unless versions
        versions.each{|version| @tag_config[version] = config[version] }
      end
      command = Commands.find(@args.shift)
      raise "The command '#{args.join(' ')}' is unknown." unless command
  
      cmd = command.new(@args, @tag_config)
      cmd.execute
      
    rescue QuitError
      puts "\nQuitting..."
    rescue => e
      puts "\nThere was an error"
      puts " Error: #{e.message}\n\n"
      puts e.backtrace.map{|m| "  in: #{m}" }
    ensure
      cmd.close if cmd
    end
    
    def parse_options
    end
    
    def command_options
      super
      sep =<<SEP
  The tags command allows you to run a subset of versions.  
  It should be used in conjunction with the run, ruby, or gems commands. 
  Multpile tags can be given in a comma separated (no spaces) list.
  
  Examples:

    C:\\>pik tags jruby run ruby -v

    C:\\>pik tags mingw,jruby gem install my_gem

SEP
      options.separator sep  
    end
    
  end

  class Tag < Command
  
    it 'Adds the given tag to the current version.'

    include ConfigFileEditor

    def execute
      config.global[:tags] ||= Hash.new
      @args.each do |arg|
        tags = config.global[:tags] 
        tags[arg] ||= []
        tags[arg] << find_config_from_path 
      end
    end
  
  end
  
end

