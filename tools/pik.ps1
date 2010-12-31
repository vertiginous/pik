pik_runner.exe $MyInvocation.MyCommand.Definition $args
if(test-path -path "$ENV:HOME\.pik\pik.ps1"){& $ENV:HOME\.pik\pik.ps1}

