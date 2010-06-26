Feature: info command
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
      date:         "2010-02-04"
      platform:     "i386-mingw32"
      patchlevel:   "398"
      full_version: "ruby 1.8.6 (2010-02-04 patchlevel 398) [i386-mingw32]"
      """
    And I should see
      """
      homes:
      gem:          "C:\temp\more spaces in path\ruby\Ruby-186-p398-2\lib\ruby\gems\1.8"
      ruby:         "C:\temp\more spaces in path\ruby\Ruby-186-p398-2"
      """
    And I should see
      """
      binaries:
      ruby:         "C:\temp\more spaces in path\ruby\Ruby-186-p398-2\bin"
      irb:          "C:\temp\more spaces in path\ruby\Ruby-186-p398-2\bin\irb.bat"
      gem:          "C:\temp\more spaces in path\ruby\Ruby-186-p398-2\bin\gem.bat"
      rake:         "C:\temp\more spaces in path\ruby\Ruby-186-p398-2\bin\rake.bat"
      """
    And I should see
      """
      environment:
      GEM_HOME:     ""
      HOME:         "C:\temp\path with spaces"
      IRBRC:        ""
      RUBYOPT:      ""
      """
    And I should see
      """
      file associations:
      .rb:           "C:\Ruby\ruby-187-p249\bin\ruby.exe" "%1" %*
      .rbw:          "C:\Ruby\ruby-187-p249\bin\rubyw.exe" "%1" %*
      """


  
  Scenario: No ruby in path
    Given there is no ruby version in the path
    When I run "pik info"
    Then I should see 
      """    

      Pik info will not work unless there is a version of ruby in the path.
      
      You can use pik switch to add one.
      
      """
   
  Scenario: Multiple rubies in path
    Given there is more than one ruby version in the path
    When I run "pik info"
    Then I should see     
      """    
      
      warning: There is more than one version of ruby in the system path
      C:\temp\more spaces in path\ruby\Ruby-191-p378-1\bin
      C:\temp\more spaces in path\ruby\Ruby-186-p398-2\bin
      """