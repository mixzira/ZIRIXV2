@echo off

echo ===-------------------------------===
echo     ZIRIX V2 (0.2.0)
echo     Developed by: ZIRAFLIX
echo     Discord: discord.gg/ziraflix
echo     Contact: contato@ziraflix.com
echo ===-------------------------------===

pause
start ..\build\FXServer.exe +exec config/config.cfg +set onesync_enableInfinity 1
exit