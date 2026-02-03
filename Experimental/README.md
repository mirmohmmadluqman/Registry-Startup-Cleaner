# Task Startup Cleaner

![Version](https://img.shields.io/badge/version-1.0-blue)
![License](https://img.shields.io/badge/license-GPL--3.0-green)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)

A lightweight, open-source Windows utility that automatically detects, backs up, and removes third-party scheduled tasks that auto-start on boot — while **protecting all Windows system tasks**.

## 🎯 Purpose

Many applications secretly create scheduled tasks to auto-launch at startup, even when they're not listed in Task Manager's Startup tab. These hidden tasks can:
- Slow down boot times
- Consume system resources
- Run without your knowledge
- Persist even after uninstalling the app

**Task Startup Cleaner** solves this by:
1. Scanning ALL scheduled tasks
2. Intelligently identifying third-party tasks
3. Backing up everything before removal
4. Safely removing only non-system tasks

## ✨ Features

- ✅ **Smart Detection** - Automatically identifies third-party vs system tasks
- ✅ **Safe Protection** - Never touches Windows system tasks
- ✅ **Complete Backup** - Creates detailed logs before any removal
- ✅ **Dual Backup Locations** - Saves to both Desktop and local Backups folder
- ✅ **Restore Instructions** - Includes guide for restoring tasks if needed
- ✅ **No Hardcoding** - Dynamically scans all tasks, not limited to specific apps
- ✅ **Detailed Reports** - Generates summary with statistics

## 📋 What Gets Removed

**Third-party scheduled tasks such as:**
- Auto-updaters (non-Microsoft)
- Background sync services
- Telemetry collectors
- App launchers (e.g., ClawdBot, spacedesk)
- Trial software reminders
- Custom user-created tasks

## 🛡️ What's PROTECTED

**System tasks that will NEVER be removed:**
- All tasks under `\Microsoft\Windows\*` (PRIMARY PROTECTION)
- Windows Defender & Security tasks
- Windows Update & UpdateOrchestrator
- Windows Maintenance tasks (Defrag, DiskCleanup, WinSAT)
- Windows Backup & System Restore
- OneDrive (official Microsoft OneDrive tasks only)
- Microsoft Edge tasks
- Microsoft Office tasks (under `\Microsoft\Office\`)
- Windows System Services (TPM, Bluetooth, Certificates, etc.)
- Hardware & Driver tasks

## 🚀 Quick Start

### Requirements
- Windows 7/8/10/11
- Administrator privileges

### Usage

1. **Download** the script:
   ```bash
   git clone https://github.com/yourusername/Task-Startup-Cleaner.git
   ```

2. **Run as Administrator**:
   - Right-click `TaskStartupCleaner.bat`
   - Select **"Run as administrator"**

3. **Review** the scan results:
   - Script will show which tasks are protected
   - Shows which tasks will be removed

4. **Press any key** to proceed or `Ctrl+C` to cancel

5. **Restart** your PC for changes to take effect

## 📁 Output Files

The script creates detailed backups in two locations:

### Desktop Backup
`Desktop\Task_Startup_Backup_YYYYMMDD_HHMMSS\`

### Local Backup
`Script_Directory\Backups\Backup_YYYYMMDD_HHMMSS\`

### Files Created:
| File | Description |
|------|-------------|
| `Removed_Tasks.txt` | Full details of all removed tasks |
| `All_Tasks_Before_Cleanup.txt` | Complete task list before cleanup |
| `How_To_Restore.txt` | Instructions for restoring tasks |
| `Summary.txt` | Operation statistics and summary |

## 🔄 Restoring Tasks

### Method 1: Reinstall the Application (Recommended)
Most applications recreate their scheduled tasks automatically when reinstalled.

### Method 2: Manual Recreation
1. Open Task Scheduler (`taskschd.msc`)
2. Use details from `Removed_Tasks.txt` to recreate the task
3. Configure triggers and actions as shown in the backup

### Method 3: Check if Really Needed
Many removed tasks are not actually needed for the app to function — only for auto-updates or telemetry.

## 📊 Example Output

```
================================================================
Task Startup Cleaner v1.0
================================================================

Scanning Scheduled Tasks...

  [PROTECTED] \Microsoft\Windows\UpdateOrchestrator\Schedule Scan
  [PROTECTED] \Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan
  [REMOVING] \OpenClaw Gateway
  [REMOVED] \OpenClaw Gateway
  [REMOVING] \SpacedeskAutoStart
  [REMOVED] \SpacedeskAutoStart

================================================================
Operation Complete!
================================================================

Tasks scanned: 245
Tasks protected: 218
Tasks removed: 27
```

## ⚠️ Important Notes

- **Always run as Administrator** - Required to modify scheduled tasks
- **Review before removing** - Check the protected list matches your expectations
- **Backup is automatic** - All tasks are backed up before removal
- **Some apps may complain** - Apps might recreate tasks or show update prompts
- **No system harm** - Only third-party tasks are removed

## 🆚 Comparison with Other Methods

| Method | Registry Startup Cleaner | Task Manager Startup Tab | Task Startup Cleaner |
|--------|-------------------------|--------------------------|----------------------|
| Removes registry Run keys | ✅ | ❌ | ❌ |
| Removes scheduled tasks | ❌ | ❌ | ✅ |
| Shows hidden tasks | ❌ | ❌ | ✅ |
| Auto-backup | ✅ | ❌ | ✅ |
| Protects system tasks | ✅ | N/A | ✅ |

**Use both scripts together for complete startup cleanup!**

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Ideas for Enhancement:
- [ ] GUI version
- [ ] Interactive mode (select which tasks to remove)
- [ ] Export to XML for easy restore
- [ ] Scheduled task analysis (show what each task does)
- [ ] Integration with Registry Startup Cleaner

## 📜 License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.

## ⚡ Related Projects

- [Registry Startup Cleaner](https://github.com/yourusername/Registry-Startup-Cleaner) - Cleans registry Run keys

## 🙏 Acknowledgments

Created to solve the persistent problem of hidden scheduled tasks that survive registry cleaning and Task Manager disabling.

## 📞 Support

If you encounter any issues:
1. Check that you're running as Administrator
2. Review the backup files for task details
3. Open an issue on GitHub with:
   - Windows version
   - Error message (if any)
   - Content of `Summary.txt`

---

**⚠️ Disclaimer:** This tool modifies Windows Task Scheduler. While it protects system tasks and creates backups, use at your own risk. The author is not responsible for any issues arising from its use.

**Made with ❤️ for a cleaner, faster Windows startup**
