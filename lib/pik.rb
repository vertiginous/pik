module Pik
  VERSION = '0.2.0'
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'yaml'
require 'pathname'
require 'fileutils'
require 'rbconfig'

require 'pik/core_ext/pathname'
require 'pik/commands'
require 'pik/commands/config_file_editor'
require 'pik/commands/batch_file_editor'
require 'pik/commands/command'
require 'pik/commands/install_command'
require 'pik/commands/list_command'
require 'pik/commands/add_command'
require 'pik/commands/help_command'
require 'pik/commands/switch_command'
require 'pik/commands/run_command'
require 'pik/commands/remove_command'
require 'pik/commands/checkup_command'
require 'pik/commands/config_command'
require 'pik/commands/gemsync_command'
require 'pik/commands/default_command'
require 'pik/commands/implode_command'
require 'pik/commands/tag_command'
require 'pik/config_file'
require 'pik/windows_env'
require 'pik/which'
require 'pik/batch_file'
require 'pik/search_path'

require 'highline'

PIK_HOME  = Pathname.new( ENV['HOME'] || ENV['USERPROFILE'] ) + '.pik'

if defined? ExerbRuntime
  PIK_BATCH = Pathname.new(ARGV.shift).ruby
else
  pik_exe = Pathname.new($0).expand_path + '..' 
  PIK_BATCH = pik_exe.dirname + "#{pik_exe.basename}.bat"
end
