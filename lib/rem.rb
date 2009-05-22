class Rem
  VERSION = '1.0.0'
end

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rem/windows_file'
require 'rem/windows_env'
require 'rem/batch_file'
require 'rem/search_path'

require 'fileutils'
require 'getopt/long'

REM_HOME = File.join( (ENV['HOME'] || ENV['USERPROFILE']) , '.rem')


