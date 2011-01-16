# -*- ruby -*-

require 'rubygems'
require 'rbconfig'
require 'uuid'
require 'hoe'

$LOAD_PATH.unshift('lib')
require 'pik'

require 'tasks/package'
require 'tasks/build'
require 'tasks/cucumber'

Hoe.plugin :git

Hoe.spec('pik') do

  developer('Gordon Thiesfeld', 'gthiesfeld@gmail.com')
  
  self.need_tar = false
  self.readme_file = 'README.rdoc'
  self.post_install_message =<<-PIM

----------------------------------------------------------------------------

*  If you're upgrading from a version <= 0.1.1, you'll want to delete the 
   pik.bat file from all of your ruby versions. Gem uninstall should do the
   trick.
    
*  Install pik to a location that's in your path, but someplace other than 
   your ruby\\bin dir If you're upgrading from a more recent version, 
   pik_install will overwrite the older files as needed.
   
     >path
      PATH=C:\\tools\\;C:\\ruby\\186-p368-mingw32\\bin;C:\\WINDOWS\\system32;C:\\WINDOWS

     >pik_install C:\\tools
  
*  If this is a first-time install, add all the versions of ruby that you 
   want to use with pik

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

# vim: syntax=Ruby

