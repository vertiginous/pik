Feature: add command
  In order to add ruby versions to pik
  A developer
  Wants a command line interface
  So that she can add versions.
  
  Scenario: add a version
    Given I have an empty config.yml
    When I run "pik add c:\bin\rubies\Ruby-186-p398\bin"
    Then I should see "Adding:  186: ruby 1.8.6 (2010-02-04 patchlevel 398) [i386-mingw32]"
    And I should see "Located at:  C:\bin\rubies\Ruby-186-p398\bin"

  Scenario: add a version that has already been added
    Given I have already added "ruby 1.8.6 (2010-02-04 patchlevel 398) [i386-mingw32]"
    When I run "pik add "C:\temp\more spaces in path\ruby\Ruby-186-p398-2\bin""
    Then I should see "This version has already been added."    
    And nothing should be added to the config file.
        
  Scenario: add a nonexistent version
    When I run "pik add C:\ruby\nonexistent_ruby\bin"
    Then I should see "Couldn't find a Ruby version at C:\ruby\nonexistent_ruby\bin"
    
  Scenario: add a version with spaces in the path.
    Given I have an empty config.yml
    When I run "pik add "C:\temp\more spaces in path\ruby\JRuby-151\bin""
    Then I should see "Adding:  151: jruby 1.5.1 (ruby 1.8.7 patchlevel 249)"
    And I should see "Located at:  C:\temp\more spaces in path\ruby\JRuby-151\bin"
    
    