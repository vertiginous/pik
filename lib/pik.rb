$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'vendor/lib'))

require 'yaml'
require 'pathname'
require 'fileutils'
require 'find'
require 'open-uri'
require 'rbconfig'

require 'hpricot'
require 'highline'

require 'pik/core_ext/pathname'
require 'pik/scripts/script_file'
require 'pik/scripts/batch_file'
require 'pik/scripts/powershell_file'
require 'pik/scripts/bash_file'
require 'pik/commands'
require 'pik/commands/config_file_editor'
require 'pik/commands/script_file_editor'
require 'pik/commands/command'
require 'pik/commands/install_command'
require 'pik/commands/list_command'
require 'pik/commands/add_command'
require 'pik/commands/help_command'
require 'pik/commands/info_command'
require 'pik/commands/use_command'
require 'pik/commands/run_command'
require 'pik/commands/refresh_command'
require 'pik/commands/remove_command'
require 'pik/commands/config_command'
require 'pik/commands/gemsync_command'
require 'pik/commands/default_command'
require 'pik/commands/implode_command'
require 'pik/commands/system_command'
require 'pik/commands/tag_command'
require 'pik/commands/uninstall_command'
require 'pik/commands/update_command'
require 'pik/config_file'
require 'pik/implementations'
require 'pik/search_path'
require 'pik/version_parser'
require 'pik/windows_env'
require 'pik/which'

module Pik
  VERSION = '0.2.8'
  Scripts = {
    '.cmd' => BatchFile, 
    '.bat' => BatchFile, 
    '.ps1' => PowershellFile, 
    '.sh'  => BashFile 
  }

  extend self

  def print_error(error)
    puts "\nThere was an error."
    puts " Error: #{error.message}\n\n"
    puts error.backtrace.map{|m| "  in: #{m}" }
    puts
  end

  def exe
    @exe ||= if defined?(ExerbRuntime)
      Pathname(File.expand_path(ExerbRuntime.filepath))
    else
      File.expand_path($0)
    end
  end

  def home
    @home ||= Pathname.new( ENV['HOME'] || ENV['USERPROFILE'] ) + '.pik'
  end
  
end

if defined?(ExerbRuntime) || $0 =~ /pik_runner/
  PIK_SCRIPT  = Pathname.new(ARGV.shift).ruby
  SCRIPT_LANG = Pik::Scripts[PIK_SCRIPT.extname]
  SCRIPT_FILE = SCRIPT_LANG.new(Pik.home + 'pik')
else
  SCRIPT_FILE = Pik::BatchFile.new(Pik.home + 'pik')
end
