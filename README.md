# Registry Startup Cleaner

A Windows batch script that safely backs up and removes unwanted startup programs from registry, while protecting essential system entries.

![Version](https://img.shields.io/badge/version-1.0-blue)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)
![License](https://img.shields.io/badge/license-GPLv3-blue)

## Purpose

This tool helps you clean up programs that automatically start with Windows by:
- Backing up all registry startup entries before removal
- Creating dual backups (Desktop + Local folder)
- Protecting essential Windows services
- Providing easy restoration instructions

## Features

-  **Dual Backup System**: Creates backups on both Desktop and in local Backups folder
-  **Safe Operation**: Protects critical entries (Default, OneDrive, SecurityHealth)
-  **Detailed Logging**: Complete record of all removed entries with restore instructions
-  **Easy Restoration**: Step-by-step guide to restore any entry if needed
-  **No Installation Required**: Portable batch script

## Requirements

- Windows 7 or later
- Administrator privileges

## Quick Start

### Download and Run

1. Download `RegistryStartupCleaner.bat`
2. Right-click the file
3. Select **"Run as administrator"**
4. Follow the on-screen prompts

### Manual Installation

```bash
git clone https://github.com/mirmohmmadluqman/registry-startup-cleaner.git
cd registry-startup-cleaner
```

Right-click `RegistryStartupCleaner.bat` and run as administrator.

## What Gets Scanned

The script scans these registry locations:

```
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce
```

## 🛡️ Protected Entries

These entries are **NEVER** removed:
- `(Default)` - Windows default value
- `OneDrive` - Microsoft OneDrive sync
- `SecurityHealth` - Windows Security

## Output Files

After running the script, you'll find backup folders containing:

### Desktop Backup
```
%USERPROFILE%\Desktop\Registry_Startup_Backup_YYYYMMDD_HHMMSS\
├── Backup_Info.txt       (Complete list of removed entries)
├── How_To_Restore.txt    (Restoration instructions)
└── Summary.txt           (Operation summary)
```

### Local Backup
```
script-directory\Backups\Backup_YYYYMMDD_HHMMSS\
├── Backup_Info.txt
├── How_To_Restore.txt
└── Summary.txt
```

## How to Restore Entries

### Method 1: Manual Restore via Registry Editor

1. Press `Win + R`, type `regedit`, press Enter
2. Navigate to the registry path shown in `Backup_Info.txt`
3. Right-click in the right panel → New → String Value
4. Enter the Entry name from `Backup_Info.txt`
5. Double-click and paste the Value

### Method 2: Command Line Restore

Open Command Prompt as Administrator:

```cmd
reg add "REGISTRY_PATH" /v "ENTRY_NAME" /t REG_SZ /d "VALUE" /f
```

Example:
```cmd
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "MyApp" /t REG_SZ /d "C:\Program Files\MyApp\app.exe" /f
```

## Important Notes

- **Always review** `Backup_Info.txt` before restoring any entries
- **Only restore entries** you recognize and trust
- **Keep backups** until you're certain everything works correctly
- **Restart your computer** after making changes for them to take effect

## Common Issues

### "Access Denied" Error
**Solution**: Make sure you're running the script as Administrator

### Script Doesn't Remove Entries
**Solution**: Some entries may be protected by Windows. Check Event Viewer for details.

### Entry Reappears After Removal
**Solution**: The program may be re-adding itself. Check:
- Task Scheduler
- Program settings/preferences
- Consider uninstalling the program

## Example Use Case

**Problem**: MiniTool Partition Wizard opens automatically on startup with update notifications

**Solution**:
1. Run Registry Startup Cleaner as administrator
2. The script finds and removes the MiniTool entry from registry
3. Backups are saved to Desktop and Backups folder
4. Restart computer
5. MiniTool no longer opens on startup
   
## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Disclaimer

This tool modifies Windows registry. While it includes safety measures and backup functionality:
- Use at your own risk
- Always keep backups
- Test on a non-critical system first
- Review what's being removed before proceeding

The authors are not responsible for any system issues or data loss.

## Acknowledgments

- Inspired by common Windows startup management tools
- Community feedback and testing

**Made with ❤️ for cleaner Windows startups**
