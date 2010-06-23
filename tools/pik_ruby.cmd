:: This is a pik launcher that runs in ruby to test changes without the compile loop.
@ECHO OFF
ruby "%~dp0pik_runner" "%~f0" %*
IF EXIST "%USERPROFILE%\.pik\pik.bat" (call "%USERPROFILE%\.pik\pik.bat")
