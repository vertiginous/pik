
module Pik

  class  Info < Command
  
    it "Displays information about the current ruby version."
    aka :checkup, :cu
    
    def execute
      puts pik_version
      
      ruby = check_path

      ruby_version = find_config_from_path(ruby)
      current = config[ruby_version]
      gem_home = current[:gem_home] || actual_gem_home
      ruby_version = Pik::VersionParser.parse(current[:version])

      puts info =<<INFO

ruby:
interpreter:  "#{ruby_version.interpreter}"
version:      "#{ruby_version.version}"
date:         "#{ruby_version.date}"
platform:     "#{ruby_version.platform}"
patchlevel:   "#{ruby_version.patchlevel}"
full_version: "#{ruby_version.full_version}"

homes:
gem:          "#{gem_home}"
ruby:         "#{ruby.dirname}"

binaries:
ruby:         "#{ruby}"
irb:          "#{Which::Irb.exe}"
gem:          "#{Which::Gem.exe}"
rake:         "#{Which::Rake.exe}"

environment:
GEM_HOME:     "#{ENV['GEM_HOME']}"
HOME:         "#{ENV['HOME']}"
IRBRC:        "#{ENV['IRBRC']}"
RUBYOPT:      "#{ENV['RUBYOPT']}"

file associations:
.rb:           #{file_associations('.rb')}
.rbw:          #{file_associations('.rbw')}
INFO
    end
    
    def check_path
      dirs = Which::Ruby.find_all
      case dirs.size 
      when 0
        $stdout.flush
        abort no_ruby
      when 1
        dirs.first
      else
        puts too_many_rubies(dirs)
        dirs.first
      end
    end
    
    def too_many_rubies(dirs)
      msg =<<MSG
      
warning: There is more than one version of ruby in the system path
#{dirs.join("\n")}
MSG
    end

    def no_ruby
      msg =<<MSG

Pik info will not work unless there is a version of ruby in the path.

You can use pik use to add one.
MSG
    end
    
    def file_associations(extension)
      @reg = Reg.new
      assoc = @reg.hkcr(extension) rescue nil
      ftype = @reg.hkcr("#{assoc}\\Shell\\open\\command") rescue nil
    end
        
  end
  
end