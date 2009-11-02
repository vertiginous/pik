Feature: uninstall command
  In order to keep the filesystem clean
  A developer
  Wants a command line tool 
  So that he can download and uninstall older ruby versions

  Scenario: uninstall IronRuby
    When I run "pik unin Ir 91 -f"
    Then I should see "** Deleting c:\temp\more spaces in path\ruby\ironruby-091"
    And I should see "091: IronRuby 0.9.1.0 on .NET 2.0.0.0 has been uninstalled."
    