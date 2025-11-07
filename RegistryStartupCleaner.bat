@echo off
setlocal enabledelayedexpansion

:: Registry Startup Cleaner v1.0
:: GitHub: [Your Repository URL]

:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ================================================================
    echo Registry Startup Cleaner - Administrator Required
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
set "DesktopBackup=%USERPROFILE%\Desktop\Registry_Startup_Backup_%timestamp%"
set "ScriptDir=%~dp0"
set "LocalBackup=%ScriptDir%Backups\Backup_%timestamp%"

:: Create backup folders
echo ================================================================
echo Registry Startup Cleaner v1.0
echo ================================================================
echo.
echo Creating backup directories...
mkdir "%DesktopBackup%" 2>nul
mkdir "%LocalBackup%" 2>nul
mkdir "%ScriptDir%Backups" 2>nul

echo Desktop backup: %DesktopBackup%
echo Local backup: %LocalBackup%
echo.

:: Define registry paths
set "RegPath1=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
set "RegPath2=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
set "RegPath3=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce"

:: Create info files for both locations
call :CreateInfoFile "%DesktopBackup%\Backup_Info.txt"
call :CreateInfoFile "%LocalBackup%\Backup_Info.txt"

call :CreateRestoreFile "%DesktopBackup%\How_To_Restore.txt"
call :CreateRestoreFile "%LocalBackup%\How_To_Restore.txt"

echo ================================================================
echo Starting Registry Scan and Backup
echo ================================================================
echo.
echo This script will:
echo 1. Backup all startup registry entries
echo 2. Remove entries (EXCEPT: Default, OneDrive, SecurityHealth)
echo 3. Save backups to Desktop AND local Backups folder
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause >nul
echo.

:: Process registries
call :ProcessRegistry "%RegPath1%" "HKCU Run"
call :ProcessRegistry "%RegPath2%" "HKLM Run"
call :ProcessRegistry "%RegPath3%" "HKCU RunOnce"

:: Create summary
call :CreateSummary

echo.
echo ================================================================
echo Operation Complete!
echo ================================================================
echo.
echo Backups saved to:
echo 1. Desktop: %DesktopBackup%
echo 2. Local: %LocalBackup%
echo.
echo Files created:
echo - Backup_Info.txt (all removed entries with registry paths)
echo - How_To_Restore.txt (restoration instructions)
echo - Summary.txt (operation summary)
echo.
echo A restart may be required for changes to take effect.
echo.
pause
goto :eof

:: ==================================================================
:: FUNCTIONS
:: ==================================================================

:CreateInfoFile
set "InfoFile=%~1"
echo Registry Startup Entries Backup > "%InfoFile%"
echo Created: %date% %time% >> "%InfoFile%"
echo. >> "%InfoFile%"
echo This folder contains registry entries that were removed from: >> "%InfoFile%"
echo - HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run >> "%InfoFile%"
echo - HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run >> "%InfoFile%"
echo - HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce >> "%InfoFile%"
echo. >> "%InfoFile%"
echo Protected entries (NOT removed): >> "%InfoFile%"
echo - (Default) >> "%InfoFile%"
echo - OneDrive >> "%InfoFile%"
echo - SecurityHealth >> "%InfoFile%"
echo. >> "%InfoFile%"
echo ================================================================ >> "%InfoFile%"
echo. >> "%InfoFile%"
goto :eof

:CreateRestoreFile
set "RestoreFile=%~1"
echo HOW TO RESTORE REGISTRY ENTRIES > "%RestoreFile%"
echo ================================ >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo METHOD 1: Manual Restore >> "%RestoreFile%"
echo ----------------------- >> "%RestoreFile%"
echo 1. Press Win + R, type 'regedit', press Enter >> "%RestoreFile%"
echo 2. Navigate to the registry path shown in Backup_Info.txt >> "%RestoreFile%"
echo 3. Right-click in the right panel and select New ^> String Value >> "%RestoreFile%"
echo 4. Enter the Entry name from Backup_Info.txt >> "%RestoreFile%"
echo 5. Double-click the new entry and paste the Value >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo METHOD 2: Command Line Restore >> "%RestoreFile%"
echo --------------------------- >> "%RestoreFile%"
echo Run Command Prompt as Administrator and use: >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo reg add "REGISTRY_PATH" /v "ENTRY_NAME" /t REG_SZ /d "VALUE" /f >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo Example: >> "%RestoreFile%"
echo reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "MyApp" /t REG_SZ /d "C:\Program Files\MyApp\app.exe" /f >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo Replace REGISTRY_PATH, ENTRY_NAME, and VALUE with info from Backup_Info.txt >> "%RestoreFile%"
echo. >> "%RestoreFile%"
echo WARNING: Only restore entries you trust and recognize! >> "%RestoreFile%"
goto :eof

:ProcessRegistry
set "RegPath=%~1"
set "RegName=%~2"

echo ----------------------------------------------------------------
echo Processing: %RegName%
echo ----------------------------------------------------------------

echo ---------------------------------------------------------------- >> "%DesktopBackup%\Backup_Info.txt"
echo Registry Path: %RegPath% >> "%DesktopBackup%\Backup_Info.txt"
echo Location: %RegName% >> "%DesktopBackup%\Backup_Info.txt"
echo ---------------------------------------------------------------- >> "%DesktopBackup%\Backup_Info.txt"

echo ---------------------------------------------------------------- >> "%LocalBackup%\Backup_Info.txt"
echo Registry Path: %RegPath% >> "%LocalBackup%\Backup_Info.txt"
echo Location: %RegName% >> "%LocalBackup%\Backup_Info.txt"
echo ---------------------------------------------------------------- >> "%LocalBackup%\Backup_Info.txt"

set "EntryCount=0"

for /f "tokens=1,2,*" %%a in ('reg query "%RegPath%" 2^>nul ^| findstr /v "HKEY"') do (
    set "EntryName=%%a"
    set "EntryType=%%b"
    set "EntryValue=%%c"
    
    if not "!EntryName!"=="(Default)" (
        if /i not "!EntryName!"=="OneDrive" (
            if /i not "!EntryName!"=="SecurityHealth" (
                echo   [BACKUP] !EntryName!
                
                echo Entry: !EntryName! >> "%DesktopBackup%\Backup_Info.txt"
                echo Type: !EntryType! >> "%DesktopBackup%\Backup_Info.txt"
                echo Value: !EntryValue! >> "%DesktopBackup%\Backup_Info.txt"
                echo. >> "%DesktopBackup%\Backup_Info.txt"
                
                echo Entry: !EntryName! >> "%LocalBackup%\Backup_Info.txt"
                echo Type: !EntryType! >> "%LocalBackup%\Backup_Info.txt"
                echo Value: !EntryValue! >> "%LocalBackup%\Backup_Info.txt"
                echo. >> "%LocalBackup%\Backup_Info.txt"
                
                reg delete "%RegPath%" /v "!EntryName!" /f >nul 2>&1
                if !errorLevel! equ 0 (
                    echo   [REMOVED] !EntryName!
                    set /a EntryCount+=1
                ) else (
                    echo   [ERROR] Failed to remove !EntryName!
                )
            )
        )
    )
)

if !EntryCount! equ 0 (
    echo   No entries to remove from this location
    echo No entries found or removed >> "%DesktopBackup%\Backup_Info.txt"
    echo No entries found or removed >> "%LocalBackup%\Backup_Info.txt"
)
echo. >> "%DesktopBackup%\Backup_Info.txt"
echo. >> "%LocalBackup%\Backup_Info.txt"
echo.
goto :eof

:CreateSummary
set "SummaryFile1=%DesktopBackup%\Summary.txt"
set "SummaryFile2=%LocalBackup%\Summary.txt"

echo Registry Startup Cleaner - Operation Summary > "%SummaryFile1%"
echo ============================================= >> "%SummaryFile1%"
echo Date: %date% >> "%SummaryFile1%"
echo Time: %time% >> "%SummaryFile1%"
echo. >> "%SummaryFile1%"
echo Operation completed successfully! >> "%SummaryFile1%"
echo. >> "%SummaryFile1%"
echo Backup Locations: >> "%SummaryFile1%"
echo 1. Desktop: %DesktopBackup% >> "%SummaryFile1%"
echo 2. Local: %LocalBackup% >> "%SummaryFile1%"
echo. >> "%SummaryFile1%"
echo Registry locations scanned: >> "%SummaryFile1%"
echo - HKEY_CURRENT_USER\...\Run >> "%SummaryFile1%"
echo - HKEY_LOCAL_MACHINE\...\Run >> "%SummaryFile1%"
echo - HKEY_CURRENT_USER\...\RunOnce >> "%SummaryFile1%"
echo. >> "%SummaryFile1%"
echo Protected entries (NOT removed): >> "%SummaryFile1%"
echo - (Default) >> "%SummaryFile1%"
echo - OneDrive >> "%SummaryFile1%"
echo - SecurityHealth >> "%SummaryFile1%"

copy "%SummaryFile1%" "%SummaryFile2%" >nul 2>&1
goto :eof