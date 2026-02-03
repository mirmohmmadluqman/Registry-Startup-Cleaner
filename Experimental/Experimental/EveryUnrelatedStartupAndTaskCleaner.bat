@echo off
setlocal enabledelayedexpansion

:: Task Startup Cleaner v1.0
:: Automatically removes third-party scheduled tasks while protecting system tasks

:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ================================================================
    echo Task Startup Cleaner - Administrator Required
    echo ================================================================
    echo.
    echo This script requires Administrator privileges.
    echo Please right-click the script and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

:: Set timestamp
set "timestamp=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "timestamp=%timestamp: =0%"

:: Set backup folders
set "DesktopBackup=%USERPROFILE%\Desktop\Task_Startup_Backup_%timestamp%"
set "ScriptDir=%~dp0"
set "LocalBackup=%ScriptDir%Backups\Backup_%timestamp%"

:: Create backup folders
echo ================================================================
echo Task Startup Cleaner v1.0
echo ================================================================
echo.
echo Creating backup directories...
mkdir "%DesktopBackup%" 2>nul
mkdir "%LocalBackup%" 2>nul
mkdir "%ScriptDir%Backups" 2>nul

echo Desktop backup: %DesktopBackup%
echo Local backup: %LocalBackup%
echo.

:: Create info files
call :CreateInfoFile "%DesktopBackup%\Removed_Tasks.txt"
call :CreateInfoFile "%LocalBackup%\Removed_Tasks.txt"

call :CreateRestoreFile "%DesktopBackup%\How_To_Restore.txt"
call :CreateRestoreFile "%LocalBackup%\How_To_Restore.txt"

echo ================================================================
echo Scanning Scheduled Tasks
echo ================================================================
echo.
echo This script will:
echo 1. Scan ALL scheduled tasks on your system
echo 2. Identify third-party auto-startup tasks
echo 3. Backup task details before removal
echo 4. Remove ONLY third-party tasks (Windows system tasks are PROTECTED)
echo.
echo CRITICAL SAFETY - Protected task patterns (will NOT be removed):
echo - All tasks under \Microsoft\ (99%% of Windows tasks)
echo - Windows Defender ^& Security tasks
echo - Windows Update ^& UpdateOrchestrator
echo - Windows Maintenance (Defrag, DiskCleanup, WinSAT)
echo - Windows Backup ^& System Restore
echo - OneDrive (official Microsoft)
echo - Microsoft Edge browser tasks
echo - Microsoft Office tasks
echo - Windows System Services (TPM, Bluetooth, Certificates, etc.)
echo.
echo WHAT WILL BE REMOVED:
echo - Third-party auto-updaters (non-Microsoft)
echo - Background sync services
echo - App launchers (e.g., ClawdBot, spacedesk, etc.)
echo - Trial software reminders
echo - Custom user-created tasks
echo.
echo Press any key to scan, or Ctrl+C to cancel...
pause >nul
echo.

:: Export current task list for reference
echo Exporting complete task list for reference...
schtasks /query /fo LIST /v > "%DesktopBackup%\All_Tasks_Before_Cleanup.txt" 2>nul
schtasks /query /fo LIST /v > "%LocalBackup%\All_Tasks_Before_Cleanup.txt" 2>nul

:: Process tasks
set "TasksFound=0"
set "TasksRemoved=0"
set "TasksProtected=0"

echo ================================================================
echo Analyzing Tasks...
echo ================================================================
echo.

:: Get all task names
for /f "skip=3 tokens=1,*" %%a in ('schtasks /query /fo LIST ^| findstr /i "TaskName:"') do (
    set "TaskName=%%b"
    set "TaskName=!TaskName:~1!"
    
    :: Skip if empty
    if not "!TaskName!"=="" (
        set /a TasksFound+=1
        call :ProcessTask "!TaskName!"
    )
)

:: Create summary
call :CreateSummary

echo.
echo ================================================================
echo Operation Complete!
echo ================================================================
echo.
echo Tasks scanned: !TasksFound!
echo Tasks protected: !TasksProtected!
echo Tasks removed: !TasksRemoved!
echo.
echo Backups saved to:
echo 1. Desktop: %DesktopBackup%
echo 2. Local: %LocalBackup%
echo.
echo Files created:
echo - Removed_Tasks.txt (all removed tasks with full details)
echo - All_Tasks_Before_Cleanup.txt (complete task list before cleanup)
echo - How_To_Restore.txt (restoration instructions)
echo - Summary.txt (operation summary)
echo.
if !TasksRemoved! gtr 0 (
    echo A restart is recommended for changes to take full effect.
)
echo.
pause
goto :eof

:: ==================================================================
:: FUNCTIONS
:: ==================================================================

:ProcessTask
set "CurrentTask=%~1"
set "IsProtected=0"

:: Check if task should be protected (system tasks)
call :IsSystemTask "!CurrentTask!" IsProtected

if !IsProtected!==1 (
    set /a TasksProtected+=1
    echo   [PROTECTED] !CurrentTask!
) else (
    :: Get task details
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

goto :eof

:IsSystemTask
set "TaskToCheck=%~1"
set "Result=0"

:: PRIMARY PROTECTION: All tasks under \Microsoft\ folder (99% of Windows tasks)
:: This catches ALL Windows system tasks in one check
echo !TaskToCheck! | findstr /i /c:"\Microsoft\" >nul && set "Result=1"

:: SECONDARY PROTECTION: Specific critical Windows tasks not under \Microsoft\
:: These are additional safety checks for edge cases

:: Windows Security & Defender (critical security)
echo !TaskToCheck! | findstr /i /c:"Windows Defender" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"SecurityHealth" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"MpCmdRun" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"WindowsDefender" >nul && set "Result=1"

:: Windows Backup & Restore (critical system recovery)
echo !TaskToCheck! | findstr /i /c:"WindowsBackup" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"SystemRestore" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"\WinRE" >nul && set "Result=1"

:: Windows Maintenance & Performance (critical system health)
echo !TaskToCheck! | findstr /i /c:"\Windows\Maintenance\" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"\Windows\Defrag\" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"\Windows\DiskCleanup\" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"\Windows\WinSAT\" >nul && set "Result=1"

:: Windows Updates (critical for security patches)
echo !TaskToCheck! | findstr /i /c:"\Windows\WindowsUpdate\" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"\Windows\UpdateOrchestrator\" >nul && set "Result=1"

:: Microsoft Official Products (OneDrive, Edge, Office)
echo !TaskToCheck! | findstr /i /c:"\Microsoft\Office\" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"MicrosoftEdge" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"\OneDrive Standalone Update Task" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"\OneDrive Reporting Task" >nul && set "Result=1"

:: Windows System Services
echo !TaskToCheck! | findstr /i /c:"\Windows\ApplicationData\" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"\Windows\AppID\" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"\Windows\CertificateServicesClient\" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"\Windows\Chkdsk\" >nul && set "Result=1"

:: Hardware & Drivers (critical for system stability)
echo !TaskToCheck! | findstr /i /c:"\Windows\TPM\" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"\Windows\Bluetooth\" >nul && set "Result=1"
echo !TaskToCheck! | findstr /i /c:"\Windows\Device\" >nul && set "Result=1"

set "%~2=!Result!"
goto :eof

:CreateInfoFile
set "InfoFile=%~1"
echo Task Startup Cleaner - Removed Tasks Log > "%InfoFile%"
echo =========================================== >> "%InfoFile%"
echo Created: %date% %time% >> "%InfoFile%"
echo. >> "%InfoFile%"
echo This file contains details of all third-party scheduled tasks >> "%InfoFile%"
echo that were removed from Windows Task Scheduler. >> "%InfoFile%"
echo. >> "%InfoFile%"
echo Protected tasks (NOT removed): >> "%InfoFile%"
echo - All tasks under \Microsoft\ >> "%InfoFile%"
echo - Windows Defender tasks >> "%InfoFile%"
echo - Windows Update tasks >> "%InfoFile%"
echo - Windows system maintenance tasks >> "%InfoFile%"
echo - OneDrive (official Microsoft) >> "%InfoFile%"
echo - Microsoft Edge tasks >> "%InfoFile%"
echo. >> "%InfoFile%"
echo ================================================================ >> "%InfoFile%"
echo REMOVED TASKS DETAILS >> "%InfoFile%"
echo ================================================================ >> "%InfoFile%"
echo. >> "%InfoFile%"
goto :eof

:CreateRestoreFile
set "RestoreFile=%~1"
echo HOW TO RESTORE SCHEDULED TASKS > "%RestoreFile%"
echo ================================ >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo WARNING: Restoring tasks should only be done if you accidentally >> "%RestoreFile%"
echo removed a task you actually need. Third-party apps usually >> "%RestoreFile%"
echo recreate their scheduled tasks when reinstalled. >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo METHOD 1: Reinstall the Application >> "%RestoreFile%"
echo ------------------------------------- >> "%RestoreFile%"
echo The safest way is to reinstall the application that created >> "%RestoreFile%"
echo the task. Most apps will recreate their scheduled tasks during >> "%RestoreFile%"
echo installation or first launch. >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo METHOD 2: Manual Task Recreation >> "%RestoreFile%"
echo --------------------------------- >> "%RestoreFile%"
echo 1. Open Task Scheduler (taskschd.msc) >> "%RestoreFile%"
echo 2. Click "Create Task" in the right panel >> "%RestoreFile%"
echo 3. Use the information from Removed_Tasks.txt to recreate: >> "%RestoreFile%"
echo    - Task Name >> "%RestoreFile%"
echo    - Triggers (when it runs) >> "%RestoreFile%"
echo    - Actions (what it executes) >> "%RestoreFile%"
echo    - Conditions and Settings >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo METHOD 3: Using XML Import (Advanced) >> "%RestoreFile%"
echo -------------------------------------- >> "%RestoreFile%"
echo If you have the original task's XML file: >> "%RestoreFile%"
echo 1. Open Task Scheduler >> "%RestoreFile%"
echo 2. Right-click "Task Scheduler Library" >> "%RestoreFile%"
echo 3. Select "Import Task" >> "%RestoreFile%"
echo 4. Browse to the XML file and import >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo IMPORTANT: Only restore tasks from applications you trust! >> "%RestoreFile%"
goto :eof

:CreateSummary
set "SummaryFile1=%DesktopBackup%\Summary.txt"
set "SummaryFile2=%LocalBackup%\Summary.txt"

echo Task Startup Cleaner - Operation Summary > "%SummaryFile1%"
echo ========================================== >> "%SummaryFile1%"
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
echo Protected task categories: >> "%SummaryFile1%"
echo - Microsoft\Windows\* (all Windows system tasks) >> "%SummaryFile1%"
echo - Windows Defender ^& Security >> "%SummaryFile1%"
echo - Windows Update ^& UpdateOrchestrator >> "%SummaryFile1%"
echo - Windows Maintenance (Defrag, DiskCleanup, WinSAT) >> "%SummaryFile1%"
echo - Windows Backup ^& System Restore >> "%SummaryFile1%"
echo - OneDrive (official Microsoft) >> "%SummaryFile1%"
echo - Microsoft Edge >> "%SummaryFile1%"
echo - Microsoft Office >> "%SummaryFile1%"
echo - Windows System Services (TPM, Bluetooth, etc.) >> "%SummaryFile1%"
echo. >> "%SummaryFile1%"
if !TasksRemoved! gtr 0 (
    echo RECOMMENDATION: Restart your PC for changes to take full effect. >> "%SummaryFile1%"
) else (
    echo No third-party startup tasks found to remove. >> "%SummaryFile1%"
)

copy "%SummaryFile1%" "%SummaryFile2%" >nul 2>&1
goto :eof
