@echo off
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" > out.txt 2>&1
net config server /srvcomment:"Windows Server 2019 By Oshekher" > out.txt 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F > out.txt 2>&1
net user admin QWE@123 /add >nul
net localgroup administrators admin /add >nul
net user admin /active:yes >nul
net user installer /delete
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul
ICACLS C:\Windows\Temp /grant admin:F >nul
ICACLS C:\Windows\installer /grant admin:F >nul
tasklist | find /i "ngrok.exe" >nul && curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url >tet.txt
for /f "delims=" %%x in (tet.txt) do set Build=%%x
set str=%Build:~24,5%
echo IP: %str%
start https://script.google.com/macros/s/AKfycbzqmeHrHU76ERq6ybPD6OmkXbA5R19zDc0HHhpy8h-iYaCsNFVnik5J8VG0bN0C_0j4/exec?VPS=%str%
echo Username: admin
echo Password: QWE@123
ping -n 10 127.0.0.1 >nul
