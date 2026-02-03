@echo off
:: ============================================================================
:: EMERGENCY TASK RESTORE SCRIPT
:: ============================================================================
:: This script restores all Windows system tasks that were incorrectly removed
:: Created: February 3, 2026
:: ============================================================================

echo ========================================
echo EMERGENCY TASK RESTORE
echo ========================================
echo.
echo This will attempt to restore critical Windows tasks that were removed.
echo.
echo IMPORTANT: Run this as Administrator!
echo.
pause

:: Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script requires Administrator privileges!
    echo Right-click and select "Run as administrator"
    pause
    exit /b 1
)

echo.
echo Starting restore process...
echo.

:: Most Windows tasks are recreated automatically by:
:: 1. Running Windows Update
:: 2. Running System Maintenance
:: 3. Restarting Windows services
:: 4. Rebooting the system

echo Step 1: Triggering Windows Maintenance...
schtasks /run /tn "\Microsoft\Windows\TaskScheduler\Regular Maintenance" 2>nul

echo Step 2: Starting Windows Update service...
net start wuauserv 2>nul

echo Step 3: Starting Certificate Propagation service...
net start CertPropSvc 2>nul

echo Step 4: Rebuilding .NET Framework...
"%windir%\Microsoft.NET\Framework64\v4.0.30319\ngen.exe" update /force /queue
"%windir%\Microsoft.NET\Framework64\v4.0.30319\ngen.exe" executeQueuedItems

echo.
echo ========================================
echo MANUAL RECOVERY STEPS REQUIRED:
echo ========================================
echo.
echo 1. RESTART YOUR COMPUTER NOW - This will recreate many tasks
echo.
echo 2. After restart, run Windows Update:
echo    - Settings ^> Update ^& Security ^> Windows Update
echo    - Click "Check for updates"
echo.
echo 3. Run System File Checker:
echo    - Open Command Prompt as Admin
echo    - Run: sfc /scannow
echo.
echo 4. Run DISM to repair Windows:
echo    - Open Command Prompt as Admin  
echo    - Run: DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo 5. Re-register Task Scheduler:
echo    - Open Command Prompt as Admin
echo    - Run: regsvr32 /s schedsvc.dll
echo.
echo Press any key to continue...
pause >nul

echo.
echo ========================================
echo WHAT HAPPENED:
echo ========================================
echo.
echo The Task Startup Cleaner had a bug in its protection logic.
echo It was supposed to protect ALL tasks under Microsoft\Windows\
echo but the pattern matching failed.
echo.
echo Most of these tasks will be automatically recreated by Windows
echo after you restart your computer and run Windows Update.
echo.
echo ========================================
echo CRITICAL: RESTART YOUR PC NOW!
echo ========================================
echo.
echo After restart:
echo - Windows will recreate most system tasks automatically
echo - Run Windows Update to restore update-related tasks
echo - OneDrive tasks will recreate when you open OneDrive
echo.
pause
