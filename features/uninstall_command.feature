Feature: uninstall command
  In order to keep the filesystem clean
  A developer
  Wants a command line tool 
  So that he can download and uninstall older ruby versions

  Scenario: uninstall IronRuby
    When I run "pik rm iron 92 -f -q" 
    And I run "pik install ironruby 0.9.2" 
    And I run "pik unin iron 92 -f"
    Then I should see "** Deleting C:\temp\path with spaces\IronRuby-092"
    And I should see "092: IronRuby 0.9.2.0 on .NET 2.0.0.0 has been uninstalled."
