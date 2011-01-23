:: This is a pik launcher that runs in ruby to test changes without the compile step.
@ECHO OFF

C:\ruby\ruby-187-p249\bin\ruby.exe "%~dp0pik_runner" "%~f0" %*

IF "%PIK_HOME%"=="" (

  IF EXIST "%HOME%\.pik\pik_run.bat" (call "%HOME%\.pik\pik_run.bat")

) ELSE (
  
  IF EXIST "%PIK_HOME%\pik_run.bat" (call "%PIK_HOME%\pik_run.bat")

)
