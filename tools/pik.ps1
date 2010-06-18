pik_runner.exe $MyInvocation.MyCommand.Definition $args
if(test-path -path "$ENV:USERPROFILE\.pik\pik.ps1"){& $ENV:USERPROFILE\.pik\pik.ps1}

