Feature: run command
  In order to test code against different ruby implementations
  A developer
  Wants an interface to the program
  So that he can run commands against all versions that pik is aware of

  Scenario: run code
    When I run "pik run "path""
    Then I should find "PATH=" 5 times
    And I should see each version's path listed
    And I should see each version listed.  
  
  Scenario: ruby command
    When I run "pik ruby -e "puts 'hello world!'" "
    Then I should find "hello world!" 5 times
    And I should see each version listed.
  
  Scenario: gem command
    When I run "pik gem -v"
    Then I should find "\n\d\.\d\.\d\n" 5 times
    And I should see each version listed.
    