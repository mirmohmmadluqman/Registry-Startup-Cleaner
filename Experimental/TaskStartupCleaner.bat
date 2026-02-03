@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Task Startup Cleaner v2.0 (EMERGENCY FIX)
:: ============================================================================
:: CRITICAL FIX: Properly protects Microsoft\Windows\ tasks
:: Previous version had a fatal bug in protection pattern matching
:: ============================================================================

title Task Startup Cleaner v2.0 - FIXED

:: Check for admin rights
echo Checking for Administrator privileges...
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ERROR: This script requires Administrator privileges!
    echo Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================================
echo Task Startup Cleaner v2.0 - EMERGENCY FIX
echo ================================================================
echo.
echo This version FIXES the critical bug in the protection logic.
echo.
echo IMPROVEMENTS:
echo - Correctly protects Microsoft\Windows\ tasks (was broken!)
echo - Correctly protects OneDrive tasks  
echo - DRY-RUN mode shows what would be removed
echo - Better logging and verification
echo.
echo ================================================================
echo.

:: Create timestamp for backup folders
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "timestamp=%dt:~0,4%-%dt:~4,2%-%dt:~6,2%_%dt:~8,2%-%dt:~10,2%-%dt:~12,2%"

:: Create backup directories
set "DesktopBackup=%USERPROFILE%\Desktop\Task_Cleanup_Backup_%timestamp%"
set "LocalBackup=%~dp0Backups\Backup_%timestamp%"

mkdir "%DesktopBackup%" 2>nul
mkdir "%LocalBackup%" 2>nul

:: Create info files
call :CreateInfoFile "%DesktopBackup%\Removed_Tasks.txt"
call :CreateInfoFile "%LocalBackup%\Removed_Tasks.txt"

call :CreateRestoreFile "%DesktopBackup%\How_To_Restore.txt"
call :CreateRestoreFile "%LocalBackup%\How_To_Restore.txt"

echo ========================================
echo DRY-RUN MODE - PREVIEW ONLY
echo ========================================
echo.
echo This will scan all tasks and show you what WOULD be removed.
echo NO tasks will actually be deleted in this preview.
echo.
echo Press any key to start the preview scan...
pause >nul
echo.

:: Export current task list for reference
echo Exporting complete task list...
schtasks /query /fo LIST /v > "%DesktopBackup%\All_Tasks_Before_Cleanup.txt" 2>nul
schtasks /query /fo LIST /v > "%LocalBackup%\All_Tasks_Before_Cleanup.txt" 2>nul

:: Initialize counters
set /a TasksFound=0
set /a TasksProtected=0
set /a TasksToRemove=0

:: Get list of all tasks
echo.
echo Scanning all scheduled tasks...
echo.
echo LEGEND:
echo [PROTECTED] = Windows system task (will NOT be removed)
echo [REMOVE]    = Third-party task (WOULD be removed)
echo.
echo ----------------------------------------------------------------

for /f "skip=3 tokens=1,* delims=\" %%A in ('schtasks /query /fo LIST ^| findstr /B /C:"TaskName"') do (
    set "CurrentTask=%%B"
    if defined CurrentTask (
        set /a TasksFound+=1
        set "IsProtected=0"
        
        :: Check if task should be protected
        call :IsSystemTask "!CurrentTask!" IsProtected
        
        if !IsProtected!==1 (
            set /a TasksProtected+=1
            echo   [PROTECTED] !CurrentTask!
        ) else (
            set /a TasksToRemove+=1
            echo   [REMOVE]    !CurrentTask!
            
            :: Log to backup file
            echo TASK TO REMOVE: !CurrentTask! >> "%DesktopBackup%\Would_Be_Removed.txt"
            echo TASK TO REMOVE: !CurrentTask! >> "%LocalBackup%\Would_Be_Removed.txt"
        )
    )
)

echo ----------------------------------------------------------------
echo.
echo ========================================
echo DRY-RUN SUMMARY
echo ========================================
echo Total tasks scanned: !TasksFound!
echo System tasks protected: !TasksProtected!
echo Third-party tasks that WOULD be removed: !TasksToRemove!
echo.
echo Backup location: %DesktopBackup%
echo Preview file: Would_Be_Removed.txt
echo.
echo ========================================
echo NEXT STEP
echo ========================================
echo.
echo Review the preview above carefully.
echo.
echo If you want to proceed with actual removal:
echo 1. Review the Would_Be_Removed.txt file
echo 2. Make sure NO system tasks are listed
echo 3. Re-run this script and confirm removal
echo.

echo.
echo Do you want to ACTUALLY REMOVE these tasks now? (Y/N)
set /p "confirm=Your choice: "

if /i not "%confirm%"=="Y" (
    echo.
    echo Cancelled. No tasks were removed.
    echo Review the preview files in: %DesktopBackup%
    pause
    exit /b 0
)

echo.
echo ========================================
echo PROCEEDING WITH ACTUAL REMOVAL
echo ========================================
echo.
pause

:: Reset counter for actual removal
set /a TasksRemoved=0

for /f "skip=3 tokens=1,* delims=\" %%A in ('schtasks /query /fo LIST ^| findstr /B /C:"TaskName"') do (
    set "CurrentTask=%%B"
    if defined CurrentTask (
        set "IsProtected=0"
        
        call :IsSystemTask "!CurrentTask!" IsProtected
        
        if !IsProtected!==0 (
            :: Get full task details before deletion
            for /f "tokens=*" %%x in ('schtasks /query /tn "!CurrentTask!" /fo LIST /v 2^>nul') do (
                set "TaskInfo=%%x"
                echo !TaskInfo! >> "%DesktopBackup%\Removed_Tasks.txt"
                echo !TaskInfo! >> "%LocalBackup%\Removed_Tasks.txt"
            )
            
            echo. >> "%DesktopBackup%\Removed_Tasks.txt"
            echo ================================================================ >> "%DesktopBackup%\Removed_Tasks.txt"
            echo. >> "%DesktopBackup%\Removed_Tasks.txt"
            
            echo. >> "%LocalBackup%\Removed_Tasks.txt"
            echo ================================================================ >> "%LocalBackup%\Removed_Tasks.txt"
            echo. >> "%LocalBackup%\Removed_Tasks.txt"
            
            echo   [REMOVING] !CurrentTask!
            
            :: Delete the task
            schtasks /delete /tn "!CurrentTask!" /f >nul 2>&1
            if !errorLevel! equ 0 (
                echo   [REMOVED] !CurrentTask!
                set /a TasksRemoved+=1
            ) else (
                echo   [ERROR] Failed to remove: !CurrentTask!
            )
        )
    )
)

call :CreateSummary

echo.
echo ================================================================
echo OPERATION COMPLETE
echo ================================================================
echo.
echo Summary:
echo - Total tasks scanned: !TasksFound!
echo - System tasks protected: !TasksProtected!
echo - Third-party tasks removed: !TasksRemoved!
echo.
echo Backup saved to:
echo 1. %DesktopBackup%
echo 2. %LocalBackup%
echo.
if !TasksRemoved! gtr 0 (
    echo RECOMMENDATION: Restart your PC for changes to take full effect.
)
echo.
pause
exit /b 0

:IsSystemTask
set "TaskToCheck=%~1"
set "Result=0"

:: CRITICAL FIX: Check for task names WITHOUT leading backslash
:: Task names are like: "Microsoft\Windows\AppID\..." NOT "\Microsoft\Windows\..."

:: PRIMARY PROTECTION: Tasks starting with "Microsoft\Windows\"
echo !TaskToCheck! | findstr /B /I /C:"Microsoft\Windows\" >nul && set "Result=1"

:: SECONDARY PROTECTION: Tasks under \Microsoft\Windows\ (with leading backslash)
echo !TaskToCheck! | findstr /I /C:"\Microsoft\Windows\" >nul && set "Result=1"

:: CRITICAL SECURITY TASKS
echo !TaskToCheck! | findstr /I /C:"Windows Defender" >nul && set "Result=1"
echo !TaskToCheck! | findstr /I /C:"SecurityHealth" >nul && set "Result=1"
echo !TaskToCheck! | findstr /I /C:"MpCmdRun" >nul && set "Result=1"

:: SYSTEM RECOVERY
echo !TaskToCheck! | findstr /I /C:"WindowsBackup" >nul && set "Result=1"
echo !TaskToCheck! | findstr /I /C:"SystemRestore" >nul && set "Result=1"

:: ONEDRIVE (Official Microsoft tasks)
:: Pattern: "OneDrive Standalone Update Task-S-1-5-21-..."
:: Pattern: "OneDrive Reporting Task-S-1-5-21-..."  
:: Pattern: "OneDrive Startup Task-S-1-5-21-..."
echo !TaskToCheck! | findstr /I /C:"OneDrive Standalone Update Task" >nul && set "Result=1"
echo !TaskToCheck! | findstr /I /C:"OneDrive Reporting Task" >nul && set "Result=1"
echo !TaskToCheck! | findstr /I /C:"OneDrive Startup Task" >nul && set "Result=1"

:: MICROSOFT EDGE
echo !TaskToCheck! | findstr /I /C:"MicrosoftEdge" >nul && set "Result=1"

set "%~2=!Result!"
goto :eof

:CreateInfoFile
set "InfoFile=%~1"
echo Task Startup Cleaner v2.0 - Removed Tasks Log > "%InfoFile%"
echo =========================================== >> "%InfoFile%"
echo Created: %date% %time% >> "%InfoFile%"
echo. >> "%InfoFile%"
echo CRITICAL FIX: This version properly protects Microsoft\Windows\ tasks >> "%InfoFile%"
echo. >> "%InfoFile%"
echo Protected tasks (NOT removed): >> "%InfoFile%"
echo - All tasks starting with Microsoft\Windows\ >> "%InfoFile%"
echo - Windows Defender ^& Security >> "%InfoFile%"
echo - Windows Backup ^& System Restore >> "%InfoFile%"
echo - OneDrive (official Microsoft tasks) >> "%InfoFile%"
echo - Microsoft Edge >> "%InfoFile%"
echo. >> "%InfoFile%"
echo ================================================================ >> "%InfoFile%"
echo REMOVED TASKS DETAILS >> "%InfoFile%"
echo ================================================================ >> "%InfoFile%"
echo. >> "%InfoFile%"
goto :eof

:CreateRestoreFile
set "RestoreFile=%~1"
echo HOW TO RESTORE SCHEDULED TASKS > "%RestoreFile%"
echo ============================== >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo If you need to restore a removed task, you have these options: >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo Option 1: Reinstall the Application >> "%RestoreFile%"
echo - Most applications recreate their scheduled tasks when reinstalled >> "%RestoreFile%"
echo - Or launch the app - it may recreate the task automatically >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo Option 2: Windows System Tasks >> "%RestoreFile%"
echo - Windows system tasks are automatically recreated: >> "%RestoreFile%"
echo   1. Restart your computer >> "%RestoreFile%"
echo   2. Run Windows Update >> "%RestoreFile%"
echo   3. Run: sfc /scannow in Admin Command Prompt >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo Option 3: Manual Recreation >> "%RestoreFile%"
echo - Open Task Scheduler (taskschd.msc) >> "%RestoreFile%"
echo - Use the details from Removed_Tasks.txt to recreate the task >> "%RestoreFile%"
echo - Right-click Task Scheduler Library ^> Create Task >> "%RestoreFile%"
echo - Enter the program path and triggers from the backup file >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo Backup Location: >> "%RestoreFile%"
echo %DesktopBackup% >> "%RestoreFile%"
echo. >> "%RestoreFile%"
goto :eof

:CreateSummary
set "SummaryFile1=%DesktopBackup%\Summary.txt"
set "SummaryFile2=%LocalBackup%\Summary.txt"

echo Task Startup Cleaner v2.0 - Operation Summary > "%SummaryFile1%"
echo ============================================== >> "%SummaryFile1%"
echo Date: %date% >> "%SummaryFile1%"
echo Time: %time% >> "%SummaryFile1%"
echo. >> "%SummaryFile1%"
echo Operation completed successfully! >> "%SummaryFile1%"
echo. >> "%SummaryFile1%"
echo Statistics: >> "%SummaryFile1%"
echo - Total tasks scanned: !TasksFound! >> "%SummaryFile1%"
echo - System tasks protected: !TasksProtected! >> "%SummaryFile1%"
echo - Third-party tasks removed: !TasksRemoved! >> "%SummaryFile1%"
echo. >> "%SummaryFile1%"
echo Backup Locations: >> "%SummaryFile1%"
echo 1. Desktop: %DesktopBackup% >> "%SummaryFile1%"
echo 2. Local: %LocalBackup% >> "%SummaryFile1%"
echo. >> "%SummaryFile1%"
echo Protected task patterns (FIXED): >> "%SummaryFile1%"
echo - Microsoft\Windows\* (all Windows system tasks) >> "%SummaryFile1%"
echo - Windows Defender ^& Security >> "%SummaryFile1%"
echo - Windows Backup ^& System Restore >> "%SummaryFile1%"
echo - OneDrive (official Microsoft tasks) >> "%SummaryFile1%"
echo - Microsoft Edge >> "%SummaryFile1%"
echo. >> "%SummaryFile1%"
if !TasksRemoved! gtr 0 (
    echo RECOMMENDATION: Restart your PC for changes to take full effect. >> "%SummaryFile1%"
) else (
    echo No third-party startup tasks found to remove. >> "%SummaryFile1%"
)

copy "%SummaryFile1%" "%SummaryFile2%" >nul
goto :eof
