Feature: implode command
  In order to delete all pik configuration data
  A developer
  Wants an interface to the program
  So that he can delete all pik configuration data
  
  
  Scenario: pik implode
    Given I have a directory "C:/temp/.pik"
    And it contains a config.yml
    When I run "pik implode -f"
    Then the directory should be deleted