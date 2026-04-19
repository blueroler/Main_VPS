@echo off
:: 1. Xóa các shortcut không cần thiết (ẩn lỗi nếu không thấy file)
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" >nul 2>&1

:: 2. Đổi comment server
net config server /srvcomment:"Windows Server 2019 By Oshekher" >nul 2>&1

:: 3. Chỉnh registry ẩn icon hệ thống
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F >nul 2>&1

:: 4. Tạo User admin (Xử lý lỗi nếu user đã tồn tại)
net user admin QWE@123 /add >nul 2>&1
net localgroup administrators admin /add >nul 2>&1
net user admin /active:yes >nul 2>&1

:: 5. Xóa user installer (Thêm 2>nul để không hiện lỗi "User name could not be found")
net user installer /delete >nul 2>&1

:: 6. Cấu hình Audio và quyền thư mục
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul
ICACLS C:\Windows\Temp /grant admin:F >nul
ICACLS C:\Windows\installer /grant admin:F >nul

:: 7. Đợi Ngrok khởi tạo (Rất quan trọng trên GitHub Actions)
echo Dang cho Ngrok khoi tao tunnel...
timeout /t 10 /nobreak >nul

:: 8. Lay URL tu Ngrok API
:retry
tasklist | find /i "ngrok.exe" >nul
if %errorlevel% equ 0 (
    curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url > tet.txt
) else (
    echo Ngrok chua chay, dang thu lai...
    timeout /t 5 >nul
    goto retry
)

:: 9. Kiem tra file tet.txt truoc khi doc
if exist tet.txt (
    for /f "delims=" %%x in (tet.txt) do set Build=%%x
) else (
    set Build=LAY_URL_THAT_BAI
)

set str=%Build%
echo =================================
echo IP: %str%
echo Username: admin
echo Password: QWE@123
echo =================================

:: Duy tri lenh ping de giu log
ping -n 10 127.0.0.1 >nul
