module Pik
  VERSION = '0.1.1'
end


require 'pathname'
require 'rbconfig'

$LOAD_PATH.unshift File.dirname(__FILE__) unless Kernel.const_defined?(:Gem)

require 'pik/core_ext/pathname'
require 'pik/commands'
require 'pik/commands/config_file_editor'
require 'pik/commands/batch_file_editor'
require 'pik/commands/command'
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
require 'pik/config_file'
require 'pik/windows_env'
require 'pik/batch_file'
require 'pik/search_path'

require 'rubygems'
require 'highline'

PIK_HOME = Pathname.new( ENV['HOME'] || ENV['USERPROFILE'] ) + '.pik'
