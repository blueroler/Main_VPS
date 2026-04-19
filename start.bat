@echo off
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

echo Waiting for Ngrok to initialize...
timeout /t 15 /nobreak >nul

:check_ngrok
tasklist | find /i "ngrok.exe" >nul
if %errorlevel% neq 0 (
    echo Ngrok is not running, retrying...
    timeout /t 5 >nul
    goto check_ngrok
)

curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url > tet.txt

if exist tet.txt (
    for /f "delims=" %%x in (tet.txt) do set Build=%%x
) else (
    set Build=FAILED_TO_GET_URL
)

set str=%Build%
echo =================================
echo IP: %str%
echo Username: admin
echo Password: QWE@123
echo =================================
ping -n 10 127.0.0.1 >nul
