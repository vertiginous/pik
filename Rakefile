# -*- ruby -*-

require 'rubygems'
require 'hoe'

$LOAD_PATH.unshift('lib')
require 'pik'

Hoe.plugin :git

Hoe.spec('pik') do |p|
  p.rubyforge_name = 'pik' # if different than lowercase project name
  p.developer('Gordon Thiesfeld', 'gthiesfeld@gmail.com')
  p.extra_deps = ['highline']
  p.post_install_message =<<-PIM

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

# vim: syntax=Ruby
