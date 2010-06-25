:: This is a pik launcher that runs in ruby to test changes without the compile loop.
@ECHO OFF
C:\Ruby\ruby-187-p249\bin\ruby.exe "%~dp0pik_runner" "%~f0" %*
IF EXIST "%USERPROFILE%\.pik\pik.bat" (call "%USERPROFILE%\.pik\pik.bat")
