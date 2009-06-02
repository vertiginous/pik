= pik

  Gordon Thiesfeld

== DESCRIPTION:

  PIK, the ruby manager for windows

== FEATURES/PROBLEMS:

  Currently, changes are to the open cmd session only.  I haven't wired up the --global switch yet.

== SYNOPSIS:

  pik commands are:
  
      add           Add another ruby location to pik.
      checkup       Checks your environment for current Ruby best practices.
      run           Runs command with all version of ruby that pik is aware of.
      rm            Remove a ruby location from pik.
      help          Diskplays help topics.
  
  
  For help on a particular command, use 'pik help COMMAND'.

== REQUIREMENTS:

  Windows, Ruby, Rubygems

== INSTALL:

  1. gem install pik
  
  2. pik add path_to_ruby_bin
  
  3. repeat step 2 as many times as necessary,
     or use 'pik add -i'
  
  4. pik run "gem install pik" 

== LICENSE:

(The MIT License)

Copyright (c) 2009 FIX

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
