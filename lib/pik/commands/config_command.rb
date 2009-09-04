module Pik

  class  Config < Command
    
    it "Usage for #{cmd_name}"
    include BatchFileEditor
    include 
    
    attr_accessor :global

    def execute
      item, value = @args.shift.downcase.split('=')
      case item
      when 'home'
        if value
          set('HOME' => value)
        else
          set('HOME' => "#{ENV['HOMEDRIVE']}#{ENV['HOMEPATH']}")
        end
      when 'rubyopt'
        case value
        when 'on'  then set('RUBYOPT' => '-rubygems')
        when 'off' then set('RUBYOPT' => nil)
        end
      when 'gem_home'
        
      else
        puts "Unknown configuration option"
      end
    end
    
    private
    
    def command_options

      @options.on("--global", "-g",
         "Make changes globally"
         ) do |value|
        @global = value
      end
      
    end

  end
  
  
end