Feature: run command
  In order to test code against different ruby implementations
  A developer
  Wants an interface to the program
  So that he can run commands against all versions that pik is aware of

  Scenario: run code
    Given I have 9 versions configured
    When I run "pik run "path" -v"
    Then I should find "PATH=" 9 times
    And I should see all paths to each version