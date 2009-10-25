# -*- ruby -*-

require 'rubygems'
require 'win32/process'

file 'tools/pik/pik.exy' do
  Dir.chdir 'tools/pik' do
    sh('ruby -rexerb/mkexy pik_runner')
  end
end

file 'tools/pik/pik.exe', :needs => 'tools/pik/pik.exy' do
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
  rm_rf 'tools/pik/pik.exy'
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
  
  self.extra_deps = {'highline' =>  '>= 0.0.0'}
  self.readme_file = 'README.rdoc'
  self.post_install_message =<<-PIM

----------------------------------------------------------------------------

1. If you've used a version previous to this one, you'll need to uninstall them.
   Don't worry, this will leave your pik config intact.
    
    pik run "gem uninstall pik"
    
2. Install the pik gem

    gem install pik
    
3. You need to install pik to a location that's in your path, but someplace other than your ruby\\bin dir

    pik_install C:\\some\\other\\path
  
4. Add all the versions of ruby that you want to use with pik

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
