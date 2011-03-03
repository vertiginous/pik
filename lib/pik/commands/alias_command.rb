module Pik

  class Alias < Command

    it "Manages aliases for ruby versions."

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

    def create(pseudonym, name)
      if version = config.find_pattern(name)
        config.create_alias(version.first, pseudonym)
      else
        Log.error "Ruby version not found."
      end
    end

    def delete(pseudonym)
      if version = config.find_alias(pseudonym)
        config[version.first].delete(:alias)
      else
        Log.error "Ruby version '#{pseudonym}' not found."
      end
    end

    def list
      config.each do |name,conf|
        puts "#{conf[:alias]} => #{VersionPattern.full(name)}" if conf[:alias]
      end
      puts
    end

    def help_message
hm =<<HM
Subcommands:
  create
    >pik alias create 187 ruby-1.8.7-p249

  list
    >pik alias list
    187 => ruby-1.8.7-p249

  delete
    >pik alias delete 187


HM
    end
  end

end