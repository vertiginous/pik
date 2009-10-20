Feature: display pik version 
  In order to know what version pik is at
  A developer
  Wants an interface to the program
  So that he can display version information
  
  Scenario: Listing versions
    When I run "pik -V"
    Then I should see "pik "
    And I should see the Pik::VERSION