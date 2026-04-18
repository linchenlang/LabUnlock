@echo off
title 机房软件终极清除
mode con cols=80 lines=25
color 0c
echo ========================================
echo   机房三大软件终极清除脚本 v2.0
echo ========================================
echo 目标：红蜘蛛、极域电子教室、学生机房管理助手
echo 操作：结束进程 - 禁用服务 - 映像劫持 - 删除文件
echo ========================================
echo.
echo 警告：此操作将强制结束上述软件的所有相关进程，
echo 并尝试删除其核心文件和注册表项。
echo 请关闭其他工作后，按任意键继续...
pause >nul

:: ----- 1. 强力终止进程 (taskkill) -----
echo [1/4] 正在终止所有相关进程...
:: 红蜘蛛及其守护进程
taskkill /F /IM REDAgent.exe 2>nul
taskkill /F /IM rsagent.exe 2>nul
taskkill /F /IM checkrs.exe 2>nul
taskkill /F /IM rscheck.exe 2>nul
:: 极域电子教室及其守护进程
taskkill /F /IM StudentMain.exe 2>nul
taskkill /F /IM TeacherMain.exe 2>nul
taskkill /F /IM Student.exe 2>nul
:: 机房管理助手
taskkill /F /IM jfglzs.exe 2>nul
taskkill /F /IM prozs.exe 2>nul
:: 针对机房管理助手每天变种的模糊匹配
for /f "skip=3 tokens=2" %%i in ('tasklist /fi "IMAGENAME eq p*.exe" /nh 2^>nul') do (
    taskkill /F /PID %%i 2>nul
)
echo 进程终止操作完成。
timeout /t 2 >nul

:: ----- 2. 禁用核心服务 (sc) -----
echo [2/4] 正在禁用核心服务...
:: 极域相关驱动服务
sc stop TDFileFilter 2>nul
sc config TDFileFilter start= disabled 2>nul
sc stop TDNetFilter 2>nul
sc config TDNetFilter start= disabled 2>nul
echo 服务禁用操作完成。
timeout /t 2 >nul

:: ----- 3. 设置映像劫持 (reg) -----
echo [3/4] 正在设置映像劫持...
set "IFEO=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"
reg add "%IFEO%\REDAgent.exe" /v Debugger /t REG_SZ /d "C:\Windows\System32\systray.exe" /f 2>nul
reg add "%IFEO%\StudentMain.exe" /v Debugger /t REG_SZ /d "C:\Windows\System32\systray.exe" /f 2>nul
reg add "%IFEO%\jfglzs.exe" /v Debugger /t REG_SZ /d "C:\Windows\System32\systray.exe" /f 2>nul
reg add "%IFEO%\prozs.exe" /v Debugger /t REG_SZ /d "C:\Windows\System32\systray.exe" /f 2>nul
echo 映像劫持设置完成。
timeout /t 2 >nul

:: ----- 4. 删除核心文件与目录 (rmdir / del) -----
echo [4/4] 正在删除核心文件与目录...
:: 删除极域安装目录
rmdir /s /q "C:\Program Files (x86)\Mythware" 2>nul
rmdir /s /q "C:\Program Files\Mythware" 2>nul
:: 删除红蜘蛛安装目录
rmdir /s /q "C:\Program Files\3000soft" 2>nul
rmdir /s /q "C:\Program Files (x86)\3000soft" 2>nul
:: 删除机房管理助手相关文件
del /f /s /q C:\jfgl\*.* 2>nul
rmdir /s /q C:\jfgl 2>nul
:: 删除常见的驱动文件
del /f /s /q C:\Windows\System32\drivers\TDFileFilter.sys 2>nul
del /f /s /q C:\Windows\System32\drivers\TDNetFilter.sys 2>nul
del /f /s /q C:\Windows\System32\drivers\3kmirror.sys 2>nul
del /f /s /q C:\Windows\System32\drivers\RedGetVideo.sys 2>nul
:: 清理temp下机房管理助手可能随机生成的文件
for /d %%i in ("C:\Program Files\temp*") do rmdir /s /q "%%i" 2>nul
echo 文件与目录删除操作完成。
timeout /t 2 >nul

cls
echo ========================================
echo       操作执行完毕！
echo ========================================
echo 1. 相关进程已被强制结束。
echo 2. 极域的限制性驱动服务已被禁用。
echo 3. 核心程序已被加入“映像劫持”，无法启动。
echo 4. 软件安装目录及驱动文件已被删除。
echo.
echo 若想恢复，重启电脑即可（如有冰点还原）。
echo 按任意键退出...
pause >nul
exit