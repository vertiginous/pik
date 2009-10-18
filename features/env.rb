config=<<CONFIG
--- 
"090: IronRuby 0.9.0.0 on .NET 2.0.0.0": 
  :gem_home: !ruby/object:Pathname 
    path: c:\\ruby\\ironruby-0.9.0\\lib\\ironruby\\gems\\1.8
  :path: !ruby/object:Pathname 
    path: C:/ruby/IronRuby-0.9.0/bin
"091: IronRuby 0.9.1.0 on .NET 2.0.0.0": 
  :gem_home: !ruby/object:Pathname 
    path: c:\\temp\\ruby\\ironruby_091\\lib\\ironruby\\gems\\1.8
  :path: !ruby/object:Pathname 
    path: c:/temp/ruby/ironruby_091/bin
"131: jruby 1.3.1 (ruby 1.8.6p287) (2009-06-15 2fd6c3d) (Java HotSpot(TM) Client VM 1.6.0_14) [x86-java]": 
  :path: !ruby/object:Pathname 
    path: C:/ruby/jruby-131/bin
"140: jruby 1.4.0RC1 (ruby 1.8.7 patchlevel 174) (2009-09-30 80c263b) (Java HotSpot(TM) Client VM 1.6.0_14) [x86-java]": 
  :path: !ruby/object:Pathname 
    path: c:/temp/ruby/jruby_140RC1/bin
"185: ruby 1.8.5 (2006-12-25 patchlevel 12) [i386-mswin32]": 
  :path: !ruby/object:Pathname 
    path: C:/ruby/185-p012-mswin32/bin
"186: ruby 1.8.6 (2008-08-11 patchlevel 287) [i386-mswin32]": 
  :path: !ruby/object:Pathname 
    path: C:/ruby/186-p287-mswin32/bin
"186: ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]": 
  :path: !ruby/object:Pathname 
    path: c:/ruby/186-p368-mingw32/bin
"191: ruby 1.9.1p129 (2009-05-12 revision 23412) [i386-mingw32]": 
  :path: !ruby/object:Pathname 
    path: C:/ruby/191-p129-mingw32/bin
"191: ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]": 
  :path: !ruby/object:Pathname 
    path: C:/ruby/191-p243-mingw32/bin
--- 
:download_dir: !ruby/object:Pathname 
  path: c:\\temp\\.pik\\downloads
:install_dir: !ruby/object:Pathname 
  path: c:\\temp\\ruby
:tags: 
  "186": 
  - "186: ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]"
  - "186: ruby 1.8.6 (2008-08-11 patchlevel 287) [i386-mswin32]"
  "191": 
  - "191: ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]"
  - "191: ruby 1.9.1p129 (2009-05-12 revision 23412) [i386-mingw32]"
  iron: 
  - "091: IronRuby 0.9.1.0 on .NET 2.0.0.0"
  - "090: IronRuby 0.9.0.0 on .NET 2.0.0.0"
  jruby: 
  - "131: jruby 1.3.1 (ruby 1.8.6p287) (2009-06-15 2fd6c3d) (Java HotSpot(TM) Client VM 1.6.0_14) [x86-java]"
  mingw: 
  - "186: ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]"
  - "191: ruby 1.9.1p129 (2009-05-12 revision 23412) [i386-mingw32]"
  - "191: ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]"
  ms: 
  - "185: ruby 1.8.5 (2006-12-25 patchlevel 12) [i386-mswin32]"
  - "185: ruby 1.8.5 (2006-12-25 patchlevel 12) [i386-mswin32]"
  - "186: ruby 1.8.6 (2008-08-11 patchlevel 287) [i386-mswin32]"
CONFIG

FAKE_PIK_HOME = 'c:/temp/.pik'

ENV['HOME'] = "C:\\temp"

Before do
  FileUtils.rm_rf FAKE_PIK_HOME
  FileUtils.mkdir_p FAKE_PIK_HOME
  File.open(File.join(FAKE_PIK_HOME, 'config.yml'), 'w'){|f| f.puts config }
end

