$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'vendor/lib'))

require 'yaml'
require 'pathname'
require 'fileutils'

require 'highline'

require 'pik/core_ext/pathname'
require 'pik/scripts/script_file'
require 'pik/scripts/batch_file'
require 'pik/scripts/powershell_file'
require 'pik/scripts/bash_file'
require 'pik/commands'
require 'pik/installer'
require 'pik/log'
require 'pik/commands/config_file_editor'
require 'pik/commands/script_file_editor'
require 'pik/commands/command'
require 'pik/commands/install_command'
require 'pik/commands/list_command'
require 'pik/commands/add_command'
require 'pik/commands/help_command'
require 'pik/commands/info_command'
require 'pik/commands/use_command'
require 'pik/commands/package_command'
require 'pik/commands/run_command'
require 'pik/commands/refresh_command'
require 'pik/commands/remove_command'
require 'pik/commands/config_command'
require 'pik/commands/default_command'
require 'pik/commands/implode_command'
require 'pik/commands/system_command'
require 'pik/commands/uninstall_command'
require 'pik/commands/update_command'
require 'pik/config_file'
require 'pik/version_pattern'
require 'pik/packages'
require 'pik/search_path'
require 'pik/version_parser'
require 'pik/windows_env'
require 'pik/which'

module Pik
  VERSION = '0.3.0'
  extend self

  Scripts = {
    '.cmd' => BatchFile, 
    '.bat' => BatchFile, 
    '.ps1' => PowershellFile, 
    '.sh'  => BashFile 
  }

  def print_error(error)
    puts "\nThere was an error."
    puts " Error: #{error.message}\n\n"
    puts error.backtrace.map{|m| "  in: #{m}" }
    puts
  end

  def exe
    @exe ||= if exerb?
      Pathname(File.expand_path(ExerbRuntime.filepath))
    else
      Pathname(File.expand_path($0))
    end
  end

  def home
    @home ||= if ENV['PIK_HOME']
      Pathname( ENV['PIK_HOME'] )
    else
      Pathname( ENV['HOME'] || ENV['USERPROFILE'] ) + '.pik'
    end
  end

  def script=(arg)
    @script = Pathname.new(arg).ruby
  end

  def script
    @script
  end

  def script_language
    @script_language ||= Scripts.fetch(script.extname, '.bat')
  end

  def script_file_name
    @script_file_name ||= Pik.home + 'pik_run'
  end

  def script_file
    @script_file ||= if exerb? 
      script_language.new(script_file_name)
    else
      BatchFile.new(script_file_name)
    end
  end

  def exerb?
    defined?(ExerbRuntime)
  end

end

