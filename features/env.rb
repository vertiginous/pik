config=<<CONFIG
--- 
"091: IronRuby 0.9.1.0 on .NET 2.0.0.0": 
  :gem_home: !ruby/object:Pathname 
    path: c:/temp/more spaces in path/ruby/IronRuby-091/lib/ironruby/gems/1.8
  :path: !ruby/object:Pathname 
    path: c:/temp/more spaces in path/ruby/ironruby-091/bin
"140: jruby 1.4.0RC2 (ruby 1.8.7 patchlevel 174) (2009-10-21 7e77f32) (Java HotSpot(TM) Client VM 1.6.0_14) [x86-java]": 
  :path: !ruby/object:Pathname 
    path: C:/temp/more spaces in path/ruby/jruby-140RC2/bin
"186: ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]": 
  :path: !ruby/object:Pathname 
    path: c:/temp/more spaces in path/ruby/ruby-186-p383/bin
"191: ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]": 
  :path: !ruby/object:Pathname 
    path: c:/temp/more spaces in path/ruby/ruby-191-p243/bin
--- 
:download_dir: !ruby/object:Pathname 
  path: C:\\temp\\path with spaces\\downloads
:install_dir: !ruby/object:Pathname 
  path: C:\\temp\\path with spaces
CONFIG

require 'yaml'
require 'pathname'
require 'fileutils'
require 'lib/pik'
require 'rbconfig'

REAL_PATH  = SearchPath.new(ENV['PATH']).replace(RbConfig::CONFIG['bindir'], 'c:/temp/more spaces in path/ruby/ruby-186-p383/bin').join

ENV['HOME'] = "C:\\temp\\path with spaces"
ENV['JAVA_HOME'] = "C:\\Program Files\\Java\\jre6"

PIK_LOG = 'log\\output.log'
TEST_PIK_HOME  = Pathname.new( ENV['HOME'] || ENV['USERPROFILE'] ) + '.pik'
FAKE_PIK_HOME = 'c:/temp/path with spaces/.pik'

Before do
  ENV['PATH'] = REAL_PATH
  FileUtils.rm_rf FAKE_PIK_HOME
  FileUtils.mkdir_p FAKE_PIK_HOME
  File.open(File.join(FAKE_PIK_HOME, 'config.yml'), 'w'){|f| f.puts config }
end

