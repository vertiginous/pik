@ECHO OFF

"%~dp0pik_runner.exe" "%~f0" %*

IF "%PIK_HOME%"=="" (

  IF EXIST "%HOME%\.pik\pik.bat" (call "%HOME%\.pik\pik.bat")

) ELSE (
  
  IF EXIST "%PIK_HOME%\pik.bat" (call "%PIK_HOME%\pik.bat")

)
