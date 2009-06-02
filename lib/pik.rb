class Pik
  VERSION = '0.0.1'
end

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'erb'
require 'highline'
require 'fileutils'
require 'rbconfig'

require 'pik/runner'
require 'pik/config'
require 'pik/checkup'
require 'pik/windows_file'
require 'pik/windows_env'
require 'pik/batch_file'
require 'pik/search_path'

PIK_HOME = File.join( (ENV['HOME'] || ENV['USERPROFILE']) , '.pik')


