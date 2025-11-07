# Frequently Asked Questions (FAQ)

## General Questions

### What is Registry Startup Cleaner?
A Windows batch script that safely removes unwanted programs from starting automatically when Windows boots, while keeping complete backups for easy restoration.

### Is it safe to use?
Yes! The script:
- Creates dual backups before making any changes
- Protects essential Windows entries
- Provides detailed logs of all actions
- Includes restoration instructions

However, always review what's being removed and keep backups until you're certain everything works.

### Do I need to install anything?
No installation required! It's a single `.bat` file that runs directly on Windows.

### What Windows versions are supported?
- ✅ Windows 11
- ✅ Windows 10
- ✅ Windows 8/8.1
- ✅ Windows 7
- ⚠️ Windows XP/Vista (may work but untested)

---

## Usage Questions

### Why do I need administrator privileges?
Modifying the Windows registry requires administrator rights. This is a security feature to prevent unauthorized changes to your system.

### Where are the backups saved?
Two locations:
1. **Desktop**: `Registry_Startup_Backup_[timestamp]`
2. **Local**: Script folder → `Backups\Backup_[timestamp]`

### How long should I keep the backups?
Recommended timeline:
- **1 week minimum**: Ensure everything works normally
- **1 month ideal**: Time to catch any issues
- **Permanent**: If you have space, keep them indefinitely

### Can I run this multiple times?
Yes! Each run creates new timestamped backups, so previous backups are never overwritten.

### What if I accidentally remove something important?
Use the restoration instructions in `How_To_Restore.txt` located in your backup folder. The process is straightforward and reversible.

---

## Technical Questions

### What registry locations does it modify?
Three locations:
```
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce
```

### What entries are protected?
These are never removed:
- `(Default)` - Windows system default value
- `OneDrive` - Microsoft OneDrive synchronization
- `SecurityHealth` - Windows Defender/Security

### Does it connect to the internet?
No. The script runs entirely locally with no external connections.

### Does it remove malware?
No. This is not an antivirus or malware removal tool. It simply backs up and removes registry startup entries. For malware, use proper antivirus software.

### Can I add more protected entries?
Yes! Edit the script and add your entries to the protection logic. Look for the lines checking for "OneDrive" and "SecurityHealth" and add similar conditions.

---

## Troubleshooting

### Script opens and closes immediately
**Cause**: Not running as administrator

**Solution**: 
1. Right-click the `.bat` file
2. Select "Run as administrator"
3. Click "Yes" on UAC prompt

### "Access Denied" error
**Cause**: Insufficient permissions

**Solution**: Ensure you're running as administrator and have rights to modify registry.

### Entry comes back after removal
**Causes**:
- Program is reinstalling the entry
- Task Scheduler has another entry
- Windows feature is managed elsewhere

**Solutions**:
1. Check Task Scheduler: Press `Win + R`, type `taskschd.msc`
2. Check program settings for "Start with Windows" option
3. Consider uninstalling the program entirely

### Can't find the backup folder
**Check these locations**:
1. Your Desktop - look for `Registry_Startup_Backup_[date]_[time]`
2. Same folder as the script → `Backups` subfolder
3. Search Windows for "Registry_Startup_Backup"

### Removed wrong entry, how to restore?

**Quick method**:
1. Open backup folder
2. Open `Backup_Info.txt`
3. Find the entry you need
4. Open Command Prompt as Administrator
5. Use this command:
```cmd
reg add "PATH" /v "NAME" /t REG_SZ /d "VALUE" /f
```
Replace PATH, NAME, and VALUE with info from `Backup_Info.txt`

---

## Security Questions

### Is this safe? Will it harm my computer?
The script is safe when used properly:
- ✅ Creates complete backups
- ✅ Open source - you can review the code
- ✅ No external connections
- ✅ Protects essential entries
- ⚠️ Like any system tool, use responsibly

### Can this remove viruses?
No. This is not antivirus software. Use proper security tools like Windows Defender or commercial antivirus for that purpose.

### Does it send any data?
No. The script is completely offline and doesn't transmit any information.

### What if I don't trust it?
Good practice! You can:
1. Read through the script (it's plain text)
2. Test on a non-critical system first
3. Create a Windows restore point before running
4. Manually backup registry before running

---

## Comparison Questions

### How is this different from Task Manager's Startup tab?
Task Manager shows startup programs but:
- Manages different locations (Startup folder, Task Scheduler)
- Doesn't modify registry entries directly
- No backup functionality

This script specifically targets registry startup locations with backup.

### How is this different from CCleaner?
CCleaner:
- Broader tool (cleans many things)
- Closed source
- Commercial software
- More features but more complex

Registry Startup Cleaner:
- Focused only on startup registry entries
- Open source
- Free
- Simple and transparent

### How is this different from MSConfig or Task Manager?
MSConfig and Task Manager disable startup items but don't remove them from registry. This script removes them entirely (with backup) for a cleaner system.

---

## Advanced Questions

### Can I customize what gets protected?
Yes! Edit the script and modify the protection conditions in the `:ProcessRegistry` function. Look for lines like:
```batch
if /i not "!EntryName!"=="OneDrive" (
```

Add your own conditions following the same pattern.

### Can I make it remove specific programs only?
Yes, but requires script modification. You'd need to change the logic from "remove everything except protected" to "remove only these specific entries."

### Can I schedule this to run automatically?
Yes, but not recommended without review. You can use Task Scheduler:
1. Open Task Scheduler
2. Create new task
3. Set trigger (e.g., weekly)
4. Set action to run the script
5. Enable "Run with highest privileges"

⚠️ **Warning**: Auto-running without review could accidentally remove wanted programs.

### Can I use this in enterprise environments?
Technically yes, but:
- Test thoroughly in your environment first
- Consider group policies instead for enterprise management
- May need modification for domain computers
- Always follow your organization's IT policies

---

## Error Messages

### "The system cannot find the file specified"
**Cause**: Registry path doesn't exist or has been moved

**Solution**: This is normal. Not all registry paths exist on all systems.

### "Error: Invalid key name"
**Cause**: Registry path format is incorrect

**Solution**: Don't modify the registry paths in the script. They're standardized Windows locations.

### "Operation completed successfully" but nothing removed
**Causes**:
- No startup entries exist in those locations
- All existing entries are protected
- Entries are in different locations

**Solution**: Check Task Manager's Startup tab to see where your startup programs are actually located.

---

## Best Practices

### Before Running
1. ✅ Create Windows restore point
2. ✅ Close all programs
3. ✅ Read through what will be removed
4. ✅ Understand what each startup program does

### After Running
1. ✅ Review `Backup_Info.txt`
2. ✅ Test your system
3. ✅ Keep backups for at least a week
4. ✅ Restart computer

### Regular Maintenance
- Run monthly to catch new startup entries
- Review backups periodically
- Clean up old backup folders after confirming they're not needed

---

## Still Have Questions?

### Resources
1. **GitHub Issues**: [Create an issue](https://github.com/mirmohmmadluqman/registry-startup-cleaner/issues)
2. **Documentation**: Read the [full README](../README.md)
3. **Quick Start**: Check the [Quick Start Guide](../QUICK_START.md)

### Before Asking
Please include:
- Windows version
- What you're trying to do
- What actually happened
- Content of `Backup_Info.txt` and `Summary.txt`
- Any error messages

---

**Last Updated**: November 7, 2025

Found a question that's not answered here? [Suggest an addition!](https://github.com/mirmohmmadluqman/registry-startup-cleaner/issues/new?labels=documentation)