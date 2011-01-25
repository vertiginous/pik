module Pik

  class Alias < Command

    it "manages aliases for ruby versions"

    include ConfigFileEditor

    def execute
      case action = @args.shift
      when 'create'
        create(*@args)
      when 'delete'
        delete(@args.shift)
      when 'list'
        list
      else
        Log.error "Unknown alias action #{action}"
      end
    end

    def create(pseudonum, name)
      if version = config.find_pattern(name)
        config[version.first][:alias] = pseudonum
      else
        Log.error "Ruby version not found."
      end
    end

    def delete(pseudonum)
      if version = config.find_alias(pseudonum)
        config[version.first].delete(:alias)
      else
        Log.error "Ruby version '#{pseudonum}' not found."
      end
    end

    def list
      config.each do |name,conf|
        puts "#{conf[:alias]} => #{VersionPattern.full(name)}" if conf[:alias]
      end
      puts
    end

  end

end