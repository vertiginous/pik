Feature: display help information
  In order to know how to use pik
  A developer
  Wants an interface to the program
  So that he can display help information
  
  Scenario: Getting help
    When I run "pik help"
    Then I should see "Usage: pik command [options]"
    And I should see "To get help with a command"
    And I should see "  pik help (command)"
    And I should see "To list all commands and descriptions:"
    And I should see "  pik help commands"