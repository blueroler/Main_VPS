@echo off
chcp 437 >nul

:: Thuc thi nhanh cac thiet lap he thong
net user admin QWE@123 /add >nul 2>&1
net localgroup administrators admin /add >nul 2>&1
net user admin /active:yes >nul 2>&1
net user installer /delete >nul 2>&1
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul

:: Tre 20 giay de chac chan Ngrok da mo tunnel
ping -n 20 127.0.0.1 >nul

set retry_count=0

:check
set /a retry_count+=1
if %retry_count% gtr 10 (
    echo Ngrok failed to start after 10 attempts.
    goto end
)

:: Thu lay URL truc tiep, neu curl loi thi quay lai check
curl -s http://127.0.0.1:4040/api/tunnels > tet.txt
findstr /C:"public_url" tet.txt >nul
if errorlevel 1 (
    echo Waiting for tunnel... (Attempt %retry_count%)
    ping -n 5 127.0.0.1 >nul
    goto check
)

:: Trich xuat URL (dung Powershell cho chuan xac thay vi jq neu may thieu jq)
for /f "usebackq tokens=*" %%a in (`powershell -command "(Get-Content tet.txt | ConvertFrom-Json).tunnels[0].public_url"`) do set Build=%%a

echo =================================
echo IP: %Build%
echo Username: admin
echo Password: QWE@123
echo =================================

:end
ping -n 10 127.0.0.1 >nul
