config=<<CONFIG
--- 
"092: IronRuby 0.9.2.0 on .NET 2.0.0.0": 
  :path: !ruby/object:Pathname 
    path: C:/temp/more spaces in path/ruby/IronRuby-092/bin
"151: jruby 1.5.1 (ruby 1.8.7 patchlevel 249) (2010-06-06 f3a3480) (Java HotSpot(TM) Client VM 1.6.0_20) [x86-java]": 
  :path: !ruby/object:Pathname 
    path: C:/temp/more spaces in path/ruby/JRuby-151/bin
"186: ruby 1.8.6 (2010-02-04 patchlevel 398) [i386-mingw32]": 
  :path: !ruby/object:Pathname 
    path: C:/temp/more spaces in path/ruby/Ruby-186-p398-2/bin
"187-test: ruby 1.8.7 (2010-01-10 patchlevel 249) [i386-mingw32]": 
  :path: !ruby/object:Pathname 
    path: C:/temp/more spaces in path/ruby/Ruby-187-p249-1/bin
"187: ruby 1.8.7 (2010-01-10 patchlevel 249) [i386-mingw32]": 
  :path: !ruby/object:Pathname 
    path: C:/Ruby/ruby-187-p249/bin
"191: ruby 1.9.1p378 (2010-01-10 revision 26273) [i386-mingw32]": 
  :path: !ruby/object:Pathname 
    path: C:/temp/more spaces in path/ruby/Ruby-191-p378-1/bin
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

REAL_PATH  = SearchPath.new(ENV['PATH']).replace(RbConfig::CONFIG['bindir'], 'C:\temp\more spaces in path\ruby\Ruby-186-p398-2\bin').join
OTHER_RUBY  = 'c:\\temp\\more spaces in path\\ruby\\Ruby-191-p378-1\\bin'

ENV['USERPROFILE'] = "C:\\temp\\path with spaces"
ENV['HOME'] = ENV['USERPROFILE']
ENV['http_proxy'] = "http://localhost:9292"

PIK_LOG = 'log\\output.log'
TEST_PIK_HOME  = Pathname.new( ENV['USERPROFILE'] ) + '.pik'
FAKE_PIK_HOME = 'c:/temp/path with spaces/.pik'
PID_FILE = 'c:/temp/proxy/proxy.pid'


def start_proxy
  proxy    = Pathname.new( File.dirname(__FILE__)) + 'proxy.ru'
  log = File.new("c:/temp/proxy/proxy.log", 'w+')
  Process.create(:app_name => "rackup.bat #{proxy} -s webrick --pid \"#{PID_FILE}\"", :startup_info => {:stdout =>  log.fileno, :stderr => log.fileno})
end


def stop_proxy
  if File.exist?(PID_FILE)
    pid = File.read(PID_FILE).to_i
    Process.kill(3,pid)
    FileUtils.rm(PID_FILE)
  end
end

start_proxy

at_exit do
  stop_proxy
end


Before do
  ENV['PATH'] = REAL_PATH
  FileUtils.rm_rf FAKE_PIK_HOME
  FileUtils.mkdir_p FAKE_PIK_HOME
  File.open(File.join(FAKE_PIK_HOME, 'config.yml'), 'w'){|f| f.puts config }
end

