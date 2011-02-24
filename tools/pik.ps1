pik_runner.exe $MyInvocation.MyCommand.Definition $args
if($ENV:PIK_HOME)
  {
    if(test-path "$ENV:PIK_HOME\pik_run.ps1"){& $ENV:HOME\.pik\pik_run.ps1 }
  }
else
  {
    if(test-path "$ENV:HOME\.pik\pik_run.ps1"){& $ENV:HOME\.pik\pik_run.ps1 }
  }
