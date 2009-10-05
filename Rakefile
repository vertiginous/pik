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

  1.  Use 'pik add' to add all versions of ruby to your pik config, 
      or use 'pik add -i' for an interactive console to do the same.
      The current ruby version is added by default.  
     
        see 'pik help add' for more info
  
  2.  Run 'pik run "gem install pik"' to install pik to all Ruby versions.

  3.  Run 'pik help' for help.

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
