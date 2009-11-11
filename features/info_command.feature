Feature: add command
  In order to add ruby versions to pik
  A developer
  Wants a command line interface
  So that she can add versions.

Scenario: Info command 
    When I run "pik info"
    Then I should see 
      """    
      
      ruby:
      interpreter:  "ruby"
      version:      "1.8.6"
      date:         "2009-08-04"
      platform:     "i386-mingw32"
      patchlevel:   "383"
      full_version: "ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]"
      
      homes:
      gem:          "c:\temp\more spaces in path\ruby\Ruby-186-p383\lib\ruby\gems\1.8"
      ruby:         "c:\temp\more spaces in path\ruby\ruby-186-p383"
      
      binaries:
      ruby:         "c:\temp\more spaces in path\ruby\ruby-186-p383\bin"
      irb:          "c:\temp\more spaces in path\ruby\ruby-186-p383\bin\irb.bat"
      gem:          "c:\temp\more spaces in path\ruby\ruby-186-p383\bin\gem.bat"
      rake:         "c:\temp\more spaces in path\ruby\ruby-186-p383\bin\rake.bat"
      
      environment:
      GEM_HOME:     ""
      HOME:         "C:\temp\path with spaces"
      IRBRC:        ""
      RUBYOPT:      ""
      
      file associations:
      .rb:           "C:\ruby\Ruby-186-p383\bin\ruby.exe" "%1" %*
      .rbw:          "C:\ruby\Ruby-186-p383\bin\rubyw.exe" "%1" %*
      """

  
  Scenario: Info command - No ruby in path
    Given there is no ruby version in the path
    When I run "pik info"
    Then I should see 
      """    

      Pik info will not work unless there is a version of ruby in the path.
      
      You can use pik switch to add one.
      
      """
   
  Scenario: Info command - Multiple rubies in path
    Given there is more than one ruby version in the path
    When I run "pik info"
    Then I should see     
      """    
      
      warning: There is more than one version of ruby in the system path
      c:\temp\more spaces in path\ruby\ruby-191-p243\bin
      c:\temp\more spaces in path\ruby\ruby-186-p383\bin
      """