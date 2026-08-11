@echo off
chcp 65001 >nul
echo 正在下载仁青音频到 D:\仁青 ...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\install_renqing_to_d.ps1"
pause
