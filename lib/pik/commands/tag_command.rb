module Pik

  class  Tags < Command
    
    it 'Runs the pik command against the given tags.'
    
    def execute
      config.global[:tags] ||= Hash.new{|h,k| h[k] = [] }
      @tag_config = config.dup
      @tag_config.clear
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
    
  end

  class Tag < Command
  
    it 'adds the given tag to the current version'

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

