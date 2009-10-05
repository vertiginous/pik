module Pik

  class  Config < Command
    
    it "Adds/modifies configuration options."
    include BatchFileEditor
    include ConfigFileEditor
    
    attr_accessor :global

    def execute
      item, value = @args.shift.downcase.split('=')
      case item
      when 'rubyopt'
        case value
        when 'on'  then set('RUBYOPT' => '-rubygems')
        when 'off' then set('RUBYOPT' => nil)
        end
      when 'gem_home'
        config[find_config_from_path][:gem_home] = if @args.include?('default') 
          Pathname.new(default_gem_home)
        else
          Pathname.new(value)
        end
      else
        puts "Unknown configuration option"
      end
    end

  end 
  
end