Feature: gem command
  In order to easily manage gems
  A developer
  Wants an interface to the program
  So that she can easily manage gems
  
  Scenario: Switching gem sets
    When I run "pik gems xyz" and check the environment
    Then I should find "GEM_HOME=.+%xyz"
    And I should find "GEM_PATH=.+%xyz"
    
  Scenario: Clearing gem sets with a defined GEM_HOME
    Given the version "1.9.1" does not have a GEM_HOME configured
    When I run "pik gems clear" and check the environment
    Then I should not see "GEM_HOME="
    And I should not see "GEM_PATH="

  Scenario: Clearing gem sets with no defined GEM_HOME
    Given the version "x" has a GEM_HOME configured
    When I run "pik gems clear" and check the environment
    Then the "GEM_HOME" variable should match the config's GEM_HOME.
    Then the "GEM_PATH" variable should match the config's GEM_HOME.
  
  Scenario: Determining current gem set
    Given I am pending
    When I run "pik gems xyz" 
    And then I run "gem in fastercsv"
    And then I run "pik gems name"
    Then I should see "xyz"
  
  Scenario: Listing all gem sets for a version
    Given I am pending
    When I run "pik gems abc"
    And then I run "gem in fastercsv"
    And then I run "pik gems def"
    And then I run "gem in fastercsv"  
    And then I run "pik gems ghi"
    And then I run "gem in fastercsv"
    And then I run "pik gems list"
    Then I should see "abc"
    And I should see "def"
    And I should see "ghi"
  
  Scenario: Dumping gem set to file
    Given I am pending
    
  Scenario: Loading a gem set file
    Given I am pending
    
  Scenario: Deleting a gem set
    Given I am pending
      

    
