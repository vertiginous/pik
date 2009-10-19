Feature: pik_install binary script
  In order to use pik
  A developer
  Wants a command line interface
  So that she can install the pik tool
  
  Scenario: pik_install
    Given I have not installed pik to C:\temp\bin
    And "C:\temp\bin" is in the system path
    When I run "pik_install C:\temp\bin"
    And then I run "C:\temp\bin\pik help"
    Then I should see "Installing to C:\temp\bin"
    And I should see "pik is installed"
    And I should see "To get help with a command"
    
    
  Scenario: pik_install to path with spaces
    Given I have not installed pik to C:\temp\path with spaces\bin
    And "C:\temp\path with spaces\bin" is in the system path
    When I run "pik_install "C:\temp\path with spaces\bin""
    And then I run "pik help"
    Then I should see "Installing to C:\temp\path with spaces\bin"
    And I should see "pik is installed"
    And I should see "To get help with a command"