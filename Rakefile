# -*- ruby -*-

require 'rubygems'
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
    
3. You need to install pik to a location that's in your path, but someplace other than your ruby\bin dir

    pik_install C:\\some\\other\\path
  
4. Add all the versions of ruby that you want to use with pik

----------------------------------------------------------------------------  

PIM

end

file 'tools/pik/pik.exy' do
  Dir.chdir 'tools/pik' do
    sh('ruby -rexerb/mkexy pik')
  end
end

file 'tools/pik/pik.exe', :needs => 'tools/pik/pik.exy' do
  Dir.chdir 'tools/pik' do
    sh('ruby -S exerb pik.exy')
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

require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

# vim: syntax=Ruby
