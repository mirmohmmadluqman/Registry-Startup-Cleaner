# Quick Start Guide

Get Registry Startup Cleaner up and running in 5 minutes!

## 🎯 What This Tool Does

Removes unwanted programs from Windows startup while keeping complete backups for safety.

## ⚡ Quick Setup

### Option 1: Download Single File

1. Download [`RegistryStartupCleaner.bat`](https://github.com/mirmohmmadluqman/registry-startup-cleaner/releases)
2. Right-click → **Run as administrator**
3. Follow on-screen prompts
4. Done! ✅

### Option 2: Clone Repository

```bash
git clone https://github.com/mirmohmmadluqman/registry-startup-cleaner.git
cd registry-startup-cleaner
```

Right-click `RegistryStartupCleaner.bat` → **Run as administrator**

## 🖥️ Step-by-Step Usage

### Step 1: Run the Script

```
Right-click RegistryStartupCleaner.bat
↓
Select "Run as administrator"
↓
Click "Yes" on UAC prompt
```

### Step 2: Review Information

The script will show:
- ✅ Backup locations (Desktop + Local)
- ✅ Registry paths to scan
- ✅ Protected entries that won't be removed

**Press any key to continue**

### Step 3: Watch the Process

You'll see real-time output:
```
Processing: HKCU Run
  [BACKUP] MiniToolPartitionWizard
  [REMOVED] MiniToolPartitionWizard
  [BACKUP] AnotherProgram
  [REMOVED] AnotherProgram
```

### Step 4: Check Results

Two backup folders are created:

📁 **Desktop**: `Registry_Startup_Backup_[timestamp]`
📁 **Local**: `script-folder\Backups\Backup_[timestamp]`

Each contains:
- `Backup_Info.txt` - All removed entries
- `How_To_Restore.txt` - Restoration guide
- `Summary.txt` - Operation summary

### Step 5: Restart Computer

```
Restart your computer for changes to take effect
```

## 📊 Example Output

```
================================================================
Registry Startup Cleaner v1.0
================================================================

Creating backup directories...
Desktop backup: C:\Users\YourName\Desktop\Registry_Startup_Backup_20251107_143025
Local backup: C:\registry-startup-cleaner\Backups\Backup_20251107_143025

================================================================
Starting Registry Scan and Backup
================================================================

This script will:
1. Backup all startup registry entries
2. Remove entries (EXCEPT: Default, OneDrive, SecurityHealth)
3. Save backups to Desktop AND local Backups folder

Press any key to continue or Ctrl+C to cancel...

----------------------------------------------------------------
Processing: HKCU Run
----------------------------------------------------------------
  [BACKUP] MiniToolPartitionWizard
  [REMOVED] MiniToolPartitionWizard

----------------------------------------------------------------
Processing: HKLM Run
----------------------------------------------------------------
  No entries to remove from this location

----------------------------------------------------------------
Processing: HKCU RunOnce
----------------------------------------------------------------
  No entries to remove from this location

================================================================
Operation Complete!
================================================================

Backups saved to:
1. Desktop: C:\Users\YourName\Desktop\Registry_Startup_Backup_20251107_143025
2. Local: C:\registry-startup-cleaner\Backups\Backup_20251107_143025

Files created:
- Backup_Info.txt (all removed entries with registry paths)
- How_To_Restore.txt (restoration instructions)
- Summary.txt (operation summary)

A restart may be required for changes to take effect.

Press any key to continue...
```

## 🔄 Restoring an Entry

### Quick Restore via Command Line

1. Open Command Prompt as Administrator
2. Use this format:

```cmd
reg add "REGISTRY_PATH" /v "ENTRY_NAME" /t REG_SZ /d "VALUE" /f
```

3. Get PATH, NAME, and VALUE from `Backup_Info.txt`

### Example:

If `Backup_Info.txt` shows:
```
Entry: MiniToolPartitionWizard
Type: REG_SZ
Value: C:\Program Files\MiniTool\app.exe
```

Restore with:
```cmd
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "MiniToolPartitionWizard" /t REG_SZ /d "C:\Program Files\MiniTool\app.exe" /f
```

## ⚠️ Common Issues

### ❌ "Access Denied"
**Fix**: Right-click the script → Run as administrator

### ❌ Script opens then closes immediately
**Fix**: Don't double-click. Right-click → Run as administrator

### ❌ Entry comes back after removal
**Causes**:
- Program is reinstalling it
- Task Scheduler has another entry
- Program settings need to be changed

**Fix**: 
1. Check Task Scheduler (`taskschd.msc`)
2. Check program's settings/preferences
3. Consider uninstalling the program

### ❌ Can't find backup folder
**Location 1**: Your Desktop
**Location 2**: Same folder as the script → `Backups` subfolder

## 🎓 Tips for Best Results

### Before Running
- ✅ Close all programs
- ✅ Create Windows restore point (optional but recommended)
- ✅ Read through the script if you're technical

### After Running
- ✅ Review `Backup_Info.txt` to see what was removed
- ✅ Keep backup folders until you're sure everything works
- ✅ Restart your computer
- ✅ Check if unwanted programs still open on startup

## 📝 What Gets Protected

These entries are **NEVER** removed:
- `(Default)` - Windows system default
- `OneDrive` - Microsoft cloud sync
- `SecurityHealth` - Windows Defender

All other startup entries are backed up and removed.

## 🆘 Need Help?

1. **Check backup files** - `Backup_Info.txt` has details
2. **Read docs** - [Full README](README.md)
3. **Check issues** - [GitHub Issues](https://github.com/mirmohmmadluqman/registry-startup-cleaner/issues)
4. **Create issue** - If problem persists

## ✨ Pro Tips

### Running Regularly
- Create desktop shortcut to the script
- Right-click shortcut → Properties → Advanced
- Check "Run as administrator"
- Now double-click works!

### Multiple Backups
- Script creates timestamped backups
- Never overwrites previous backups
- Safe to run multiple times

### Finding Startup Programs
Not sure what's starting automatically?
1. Press `Ctrl + Shift + Esc` (Task Manager)
2. Go to "Startup" tab
3. See what's enabled

Then run this script to remove registry entries!

---

**That's it! You're ready to clean your startup! 🚀**

For detailed documentation, see [README.md](README.md)