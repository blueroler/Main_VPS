@echo off
chcp 437 >nul
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" >nul 2>&1
net config server /srvcomment:"Windows Server 2019 By Oshekher" >nul 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F >nul 2>&1
net user admin QWE@123 /add >nul 2>&1
net localgroup administrators admin /add >nul 2>&1
net user admin /active:yes >nul 2>&1
net user installer /delete >nul 2>&1
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul
ICACLS C:\Windows\Temp /grant admin:F >nul
ICACLS C:\Windows\installer /grant admin:F >nul

:: Thay the timeout bang ping de tao tre 15 giay
ping -n 15 127.0.0.1 >nul

:check
tasklist | find /i "ngrok.exe" >nul
if errorlevel 1 (
    ping -n 5 127.0.0.1 >nul
    goto check
)

curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url > tet.txt

if exist tet.txt (
    for /f "delims=" %%x in (tet.txt) do set Build=%%x
)

echo IP: %Build%
echo User: admin
echo Pass: QWE@123
ping -n 10 127.0.0.1 >nul
