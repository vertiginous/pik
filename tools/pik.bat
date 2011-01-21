@ECHO OFF

"%~dp0pik_runner.exe" "%~f0" %*

IF "%PIK_HOME%"=="" (

  IF EXIST "%HOME%\.pik\pik_run.bat" (call "%HOME%\.pik\pik_run.bat")

) ELSE (
  
  IF EXIST "%PIK_HOME%\pik_run.bat" (call "%PIK_HOME%\pik_run.bat")

)
