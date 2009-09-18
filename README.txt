= pik

http://github.com/vertiginous/pik/tree/master
Gordon Thiesfeld

== DESCRIPTION:

  Pik is a tool to switch between multiple versions of ruby on Windows.  
  
  Or to put it another way
  
    <code>doskey rvm=pik $*</code>
  
  You have to tell it where your different ruby versions live using 
  'pik add'.  Then you can change to one by using 'pik switch'.
  
  It also has a "sort of" multiruby functionality in 'pik run'.
   

== FEATURES/PROBLEMS:

  Currently, changes are to the open cmd session only.  I haven't wired up the --global switch yet.

  Specs are very incomplete.

  'pik config' could be dangerous.  Use only if you know what you're doing.

  Only works on MRI at present.

== SYNOPSIS:

  <code>
  pik commands are:
  
      add           Add another ruby location to pik.
      checkup       Checks your environment for current Ruby best practices.
      list|ls       Lists ruby versions that pik is aware of.
      run           Runs command with all version of ruby that pik is aware of.
      remove|rm     Remove a ruby location from pik.
      switch|sw     Switches to another ruby location.
      help          Displays help topics.
  
  
  For help on a particular command, use 'pik help COMMAND'.
  </code>

  Example:

  <code>
    C:\>pik run "gem in hpricot --no-ri --no-rdoc"
     == Running with 185: ruby 1.8.5 (2006-12-25 patchlevel 12) [i386-mswin32] ==
    Successfully installed hpricot-0.8.1-x86-mswin32
    1 gem installed
    
     == Running with 186: ruby 1.8.6 (2008-08-11 patchlevel 287) [i386-mswin32] ==
    Successfully installed hpricot-0.8.1-x86-mswin32
    1 gem installed
    
     == Running with 186: ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32] == 
    Building native extensions.  This could take a while...
    Successfully installed hpricot-0.8.1
    1 gem installed
    
     == Running with 191: ruby 1.9.1p0 (2009-01-30 revision 21907) [i386-mingw32] == 
    Building native extensions.  This could take a while...
    ERROR:  Error installing hpricot:
            ERROR: Failed to build gem native extension.
    
    ... Errors because I haven't added the devkit ...
    
     == Running with 191: ruby 1.9.1p129 (2009-05-12 revision 23412) [i386-mingw32] == 
    Building native extensions.  This could take a while...
    Successfully installed hpricot-0.8.1
    1 gem installed
    
    </code>
    
== REQUIREMENTS:

  Windows, Ruby, Rubygems

== INSTALL:

  1. gem install vertiginous-pik
  
  2. pik add path_to_ruby_bin # add your current ruby's bin dir
  
  3. repeat step 2 once for each version of ruby you have,
     or use 'pik add -i' for interactive console to do the same.
  
  4. pik run "gem install vertiginous-pik" 

== LICENSE:

(The MIT License)

Copyright (c) 2009 Gordon Thiesfeld

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
