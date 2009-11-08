
module Pik

  class  Gems < Command
  
    it "Manages gem sets"
    
    def execute
      case @args.first
      when 'select','clear','dump','load','name','list','dir','delete'
        send(@args.shift)
      else
        select
      end
    end
    
    # gems subcommands  
  
    def select
    end
    
    # selects default GEM_HOME
    def clear
    end
      
    def dump
      gem_set_file = @args.first || "#{gem_set_name}.gems"
      File.open(gem_set_file, 'w+'){ |f| f.puts gem_set_dump }
    end
    
    def load
      File.read(@args.first).split("\n").each do |gem_set_item|
        next if gem_set_item.match(/^\s*#/)
        if gem_set_dump.include? gem_set_item
          puts "** Gem #{gem_set_item} already installed"
        else
          puts "** Installing #{gem_set_item}"
          sh "#{gem_cmd} install -q --no-rdoc --no-ri #{gem_set_item}"
        end
      end
    end
    
    def name
      puts gem_set_name
    end
    
    def list
    end
    
    def dir
      puts ENV['GEM_HOME'] || actual_gem_home
    end
    
    def delete
      # to_delete = @args.first
      # if to_delete.nil?
      #   raise "A gemset must be specified in order to delete."
      # else
      #   if 
      # end
    end
    
    # helper methods
    
    def gem_set_name
      ENV['GEM_HOME'] ? Pathname(ENV['GEM_HOME']).basename : 'default'
    end
    
    def gem_set_dump
      @gem_set_dump ||= `#{gem_cmd} list`.
      scan(/(.+) \((.+)\)/).
      map{|name, versions| versions.split(', ').map{|version| "#{name} -v#{version}" } }.
      flatten
    end
    
    def gem_cmd
      Which::Gem.exe.basename
    end
     
  end
  
end