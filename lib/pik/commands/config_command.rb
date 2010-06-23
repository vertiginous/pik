module Pik

  class  Config < Command
    
    it "Adds/modifies configuration options."
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
          Pathname(default_gem_home)
        else
          Pathname(value)
        end
      when 'downloads', 'download_dir'
        config.global[:download_dir] = Pathname(value)
      when 'installs', 'install_dir'
        config.global[:install_dir] = Pathname(value)
      when 'devkit', 'devkit_dir'
        config.global[:devkit] = Pathname(value)
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
    
    def command_options
      super
      sep =<<SEP
If no options are given, the current and global configuration
is displayed.

  Configuration options are:
    
    rubyopt      on = -rubygems, off = blank         
    gem_home     Location of current version's GEM_HOME env. var.
    downloads    Location where 'pik install' will download new versions
    installs     Location where 'pik install' will install new versions

SEP
      options.separator sep  
    end
    
  end 
  
end

