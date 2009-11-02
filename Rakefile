# -*- ruby -*-

require 'rubygems'
require 'rbconfig'
require 'win32/process'

ENV['SPEC_OPTS']= '-O spec/spec.opts'

file 'tools/pik/pik_runner.exy' do
  Dir.chdir 'tools/pik' do
    sh('ruby -rexerb/mkexy pik_runner -v')
  end
  exy = YAML.load(File.read('tools/pik/pik_runner.exy'))
  zlib1 = {
    'file' =>  File.join(RbConfig::CONFIG['bindir'], 'zlib1.dll'),
    'type' => 'extension-library'
  }
  exy['file']['zlib1.dll']  = zlib1
  File.open('tools/pik/pik_runner.exy', 'w+'){ |f| f.puts YAML.dump(exy) }
end

file 'tools/pik/pik.exe', :needs => ['tools/pik/pik_runner.exy'] do
  Dir.chdir 'tools/pik' do
    sh('ruby -S exerb pik_runner.exy')
  end
end

task :build, :needs => 'tools/pik/pik.exe'

task :install, :needs => :build do
  sh('ruby bin/pik_install C:\\bin')
end

task :clobber_exe do
  rm_rf 'tools/pik/pik.exe'
end

task :clobber_exy, :needs => :clobber_exe do
  rm_rf 'tools/pik/pik_runner.exy'
end

task :rebuild, :needs => [:clobber_exy, :build]
task :reinstall, :needs => [:clobber_exy, :install]

task :package => :rebuild

require 'hoe'

$LOAD_PATH.unshift('lib')
require 'pik'

Hoe.plugin :git

Hoe.spec('pik') do

  developer('Gordon Thiesfeld', 'gthiesfeld@gmail.com')
  
  self.need_tar = false
  self.extra_deps = {'highline' =>  '>= 0.0.0'}
  self.readme_file = 'README.rdoc'
  self.post_install_message =<<-PIM

----------------------------------------------------------------------------

*  If you're upgrading from a version <= 0.1.1, you'll want to delete the pik.bat file
   from all of your ruby versions. Gem uninstall should do the trick.
    
*  Install pik to a location that's in your path, but someplace other than your ruby\\bin dir
   If you're upgrading from a more recent version, pik_install will overwrite the older files as needed.
   
    >path
      PATH=C:\\tools\\;C:\\ruby\\186-p368-mingw32\\bin;C:\\WINDOWS\\system32;C:\\WINDOWS

    >pik_install C:\\tools
  
*  If this is a first-time install, add all the versions of ruby that you want to use with pik

    >pik add
    Adding:  186: ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]
     Located at:  c:/ruby/186-p368-mingw32/bin
    
    >pik add C:\\ruby\\IronRuby-091\\bin
    Adding:  091: IronRuby 0.9.1.0 on .NET 2.0.0.0
     Located at:  C:/ruby/IronRuby-091/bin
    
    >pik add C:\\ruby\\jruby-1.4.0RC1\\bin
    Adding:  140: jruby 1.4.0RC1 (ruby 1.8.7 patchlevel 174) (2009-09-30 80c263b) (Java HotSpot(TM) Client VM 1.6.0_14) [x86-java]
     Located at:  C:/ruby/jruby-1.4.0RC1/bin
     

----------------------------------------------------------------------------  

PIM

end

require 'cucumber'
require 'cucumber/rake/task'

namespace :cucumber do

  directory "C:/temp"
  
  desc "sets up C:\\temp for pik's cuke tests"
  task :setup => "C:/temp" do
    ENV['HOME'] = "C:\\temp"
    sh "pik config installs=\"C:\\temp\\more spaces in path\\ruby\""
    sh "pik install jruby"
    sh "pik install ironruby"
    sh "pik install ruby"
    sh "pik install ruby 1.8"
    sh "pik gem in rake"
  end
  
  namespace :phonyweb do
    
    task :start => 'hosts:add' do
      @web = Process.create(:app_name => "ruby C:\\scripts\\repo\\pik\\phony_web\\server.rb")
    end
    
    task :kill => 'hosts:remove' do
      Process.kill(3, @web.process_id)
    end
  end
  
  # this is used with the phony web server for 
  # testing the install and list command
  # without sucking up bandwidth.  It also makes the
  # tests run faster
  namespace :hosts do
   
    HOSTS = File.join(ENV['SystemRoot'], 'System32','drivers','etc','hosts')
    desc "adds fake hosts to system's hosts file"
    task :add do
      File.open(HOSTS,'a+'){|f|
       f.puts "127.0.0.1   www.jruby.org rubyforge.org www.rubyforge.org jruby.kenai.com dist.codehaus.org"
      }
    end
    
    desc "remove fake hosts from system's hosts file"
    task :remove do
      new_hosts = File.open(HOSTS, 'r').readlines.reject{ |i| i =~ /^127\.0\.0\.1   www\.jruby\.org/ }
      File.open(HOSTS, 'w+'){|f| f.puts new_hosts }
    end
   
    task :rm => :remove
   
  end
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features  -f html -o ../pik_cucumber.html -f progress"
end

task :cuke => ['cucumber:phonyweb:start', :features, 'cucumber:phonyweb:kill']

# vim: syntax=Ruby
