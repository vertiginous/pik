@ECHO OFF
"%~dp0pik_runner.exe" "%~f0" %*
IF EXIST "%HOME%\.pik\pik.bat" (call "%HOME%\.pik\pik.bat")
