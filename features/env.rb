config=<<CONFIG
--- 
"091: IronRuby 0.9.1.0 on .NET 2.0.0.0": 
  :path: !ruby/object:Pathname 
    path: c:/temp/more spaces in path/ruby/ironruby_091/bin
"140: jruby 1.4.0RC1 (ruby 1.8.7 patchlevel 174) (2009-09-30 80c263b) (Java HotSpot(TM) Client VM 1.6.0_14) [x86-java]": 
  :path: !ruby/object:Pathname 
    path: C:/temp/more spaces in path/ruby/jruby_140RC1/bin
"186: ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]": 
  :path: !ruby/object:Pathname 
    path: c:/ruby/186-p368-mingw32/bin
"186: ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]": 
  :path: !ruby/object:Pathname 
    path: c:/temp/more spaces in path/ruby/ruby_186-p383/bin
"191: ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]": 
  :path: !ruby/object:Pathname 
    path: c:/temp/more spaces in path/ruby/ruby_191-p243/bin
--- 
:download_dir: !ruby/object:Pathname 
  path: C:\\temp\\path with spaces\\downloads
:install_dir: !ruby/object:Pathname 
  path: C:\\temp\\path with spaces
CONFIG

REAL_PATH  = ENV['PATH']
FAKE_PIK_HOME = 'c:/temp/path with spaces/.pik'
ENV['HOME'] = "C:\\temp\\path with spaces"
ENV['JAVA_HOME'] = "C:\\Program Files\\Java\\jre6"

Before do
  ENV['PATH'] = REAL_PATH
  FileUtils.rm_rf FAKE_PIK_HOME
  FileUtils.mkdir_p FAKE_PIK_HOME
  File.open(File.join(FAKE_PIK_HOME, 'config.yml'), 'w'){|f| f.puts config }
end

