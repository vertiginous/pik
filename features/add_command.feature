Feature: add command
  In order to add ruby versions to pik
  A developer
  Wants a command line interface
  So that she can add versions.
  
  Scenario: initial add version
    Given I have no .pik directory
    When I run "pik add"
    Then I should see "creating"
    Then I should see "Adding:  "
    And I should see "Located at:  "

  Scenario: add a version
    Given I have an empty config.yml
    When I run "pik add C:\ruby\186-p368-mingw32\bin"
    Then I should see "Adding:  186: ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]"
    And I should see "Located at:  C:/ruby/186-p368-mingw32/bin"

  Scenario: add a version that has already been added
    Given I have already added "ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]"
    When I run "pik add C:\ruby\186-p368-mingw32\bin"
    Then I should see "This version has already been added."    
    And nothing should be added to the config file.
        
  Scenario: add a nonexistent version
    When I run "pik add C:\ruby\nonexistent_ruby\bin"
    Then I should see "Couldn't find a Ruby version at C:\ruby\nonexistent_ruby\bin"
