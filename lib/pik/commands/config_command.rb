module Pik

  class  Config < Command
    
    it "Adds/modifies configuration options."
    include BatchFileEditor
    include ConfigFileEditor
    
    attr_accessor :global

    def execute
      return list if @args.empty?
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
      when 'downloads', 'download_dir'
        config.global[:download_dir] = Pathname.new(value)
      when 'installs', 'install_dir'
        config.global[:install_dir] = Pathname.new(value)
      when 'list'
        list
      else
        puts "Unknown configuration option"
      end
    end
    
    def list
      version = find_config_from_path
      puts "** CURRENT CONFIGURATION **"
      puts
      puts version + ' *'
      config[version].each{|k,v| puts "     %s: %s" % [k, v]}
      puts
      puts "** GLOBAL CONFIGURATION **"
      puts
      cfg = stringify(config.global.dup)
      puts cfg.to_yaml.gsub(/"/, '')
    end
    
    def stringify(item)
      case item
      when Array
        item.map{|i| stringify(i) }
      when Hash
        h = {}
        item.map{|k,v| h[stringify(k)] = stringify(v)} 
        h
      else
        item.to_s
      end
    end
    
  end 
  
end

