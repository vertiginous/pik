@ECHO OFF
"%~dp0pik_runner.exe" "%~f0" %*
IF EXIST "%USERPROFILE%\.pik\pik.bat" (call "%USERPROFILE%\.pik\pik.bat")
