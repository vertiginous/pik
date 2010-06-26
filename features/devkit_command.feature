Feature: devkit command
  In order to have a development environment
  A developer
  Wants a command line interface
  So that she can install binary gems.
  
  Scenario: add a version
    When I run "pik devkit update"
    Then I should see "Updating devkit batch files for:"
    And each 'mingw' version should have a 'gcc.bat'
    And each 'mingw' version should have a 'sh.bat'
    And each 'mingw' version should have a 'make.bat'
