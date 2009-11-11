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
    
  Scenario: pik_install with no arguments
    Given I have not installed pik to C:\temp\path with spaces\bin
    When I run "pik_install"
    Then I should see
    """
    Usage:  pik_install path\to\install

    You should install to a directory that is in your system path,
    or add the directory to your system path.  Do not install to 
    your ruby's bin directory because pik will remove it from the
    path when switching versions.
    
      Example: 
      C:\>path
    
    PATH=C:\tools;C:\ruby\Ruby-186-p383\bin;C:\WINDOWS\system32;...
      
    C:\>pik_install C:\tools
    
    """
    
  Scenario: pik_install to dir not in system path
    Given I have not installed pik to C:\temp\path with spaces\bin
    When I run "pik_install "C:\temp\path with spaces\bin""
    Then I should see
    """
    The directory you installed to is not in the sytem path.
    C:\temp\path with spaces\bin
    
    You will need to add it.
    """