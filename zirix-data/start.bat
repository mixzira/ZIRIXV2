@echo off

echo ===-------------------------------===
echo     ZIRIX V2 (0.2.0)
echo     Developed by: ZIRAFLIX
echo     Discord: discord.gg/MgvQnUaTJ4
echo     Contact: contato@ziraflix.com
echo ===-------------------------------===

pause
start ..\build\FXServer.exe +exec config/config.cfg +set onesync on +set onesync_population false
exit
