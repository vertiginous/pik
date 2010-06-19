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
require 'pik/scripts/ps_file'
require 'pik/scripts/bash_file'
require 'pik/commands'
require 'pik/commands/config_file_editor'
require 'pik/commands/script_file_editor'
require 'pik/commands/command'
require 'pik/commands/devkit_command'
require 'pik/commands/install_command'
require 'pik/commands/list_command'
require 'pik/commands/add_command'
require 'pik/commands/help_command'
require 'pik/commands/info_command'
require 'pik/commands/use_command'
require 'pik/commands/run_command'
require 'pik/commands/remove_command'
require 'pik/commands/config_command'
require 'pik/commands/gemsync_command'
require 'pik/commands/default_command'
require 'pik/commands/implode_command'
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
  VERSION = '0.2.7'
  Scripts = {
    '.cmd' => BatchFile, 
    '.bat' => BatchFile, 
    '.ps1' => PsFile, 
    '.sh'  => BashFile 
  }

  def self.print_error(error)
    puts "\nThere was an error."
    puts " Error: #{error.message}\n\n"
    puts error.backtrace.map{|m| "  in: #{m}" }
    puts
  end
  
end


Pik::Commands.deprecate(:checkup => "The checkup command is deprecated, using the info command instead.")
Pik::Commands.deprecate(:cu => "The cu command is deprecated, using the info command instead.")

PIK_HOME    = Pathname.new( ENV['USERPROFILE'] ) + '.pik'

if defined?(ExerbRuntime) || $0 =~ /pik_runner/
  PIK_SCRIPT  = Pathname.new(ARGV.shift).ruby
  SCRIPT_LANG = Pik::Scripts[PIK_SCRIPT.extname]
  SCRIPT_FILE = SCRIPT_LANG.new(PIK_HOME + 'pik')
else
  SCRIPT_FILE = Pik::BatchFile.new(PIK_HOME + 'pik')
end
