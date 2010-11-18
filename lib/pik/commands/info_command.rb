require 'ostruct'

module Pik

  class  Info < Command
  
    it "Displays information about the current ruby version."
    aka :checkup, :cu
    
    def execute
      puts pik_version
      
      ruby = check_path
      
      current = get_full_version_from_config(ruby) rescue get_full_version rescue nil

      ruby_version = current ? Pik::VersionParser.parse(current) : OpenStruct.new

      gemset = $1 if ENV['GEM_HOME'] =~ /.+@(.+)$/

      @hl.say info =<<INFO

ruby:
interpreter:  "#{ruby_version.interpreter}"
version:      "#{ruby_version.version}"
date:         "#{ruby_version.date}"
platform:     "#{ruby_version.platform}"
patchlevel:   "#{ruby_version.patchlevel}"
full_version: "#{ruby_version.full_version}"

homes:
gem:          "#{ENV['GEM_HOME']}"
ruby:         "#{ruby.dirname rescue nil}"

binaries:
ruby:         "#{ruby rescue nil}"
irb:          "#{Which::Irb.exe}"
gem:          "#{Which::Gem.exe}"
rake:         "#{Which::Rake.exe}"

environment:
PATH:         "#{ENV['PATH']}"
GEM_HOME:     "#{ENV['GEM_HOME']}"
GEM_PATH:     "#{ENV['GEM_PATH']}"
BUNDLE_PATH:  "#{ENV['BUNDLE_PATH']}"
HOME:         "#{ENV['HOME']}"
IRBRC:        "#{ENV['IRBRC']}"
RUBYOPT:      "#{ENV['RUBYOPT']}"
gemset:       "#{gemset}"

file associations:
.rb:           #{file_associations('.rb')}
.rbw:          #{file_associations('.rbw')}
INFO
    end

    def get_full_version_from_config(ruby)
      find_config_from_path(ruby)
      current = config[current_version][:version]
    end
    
    def check_path
      dirs = Which::Ruby.find_all
      case dirs.size 
      when 0
      #   $stdout.flush
      #   abort no_ruby
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

#     def no_ruby
#       msg =<<MSG

# Pik info will not work unless there is a version of ruby in the path.

# You can use pik switch to add one.
# MSG
#     end
    
    def file_associations(extension)
      @reg  = Reg.new
      assoc = @reg.hkcr(extension) rescue nil
      ftype = @reg.hkcr("#{assoc}\\Shell\\open\\command") rescue nil
    end
        
  end
  
end