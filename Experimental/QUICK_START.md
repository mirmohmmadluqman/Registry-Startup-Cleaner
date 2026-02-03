# QUICK START GUIDE

## Task Startup Cleaner - Get Started in 2 Minutes

### Step 1: Download
```bash
git clone https://github.com/yourusername/Task-Startup-Cleaner.git
cd Task-Startup-Cleaner
```

### Step 2: Run as Administrator
1. Right-click `TaskStartupCleaner.bat`
2. Select **"Run as administrator"**
3. If prompted by UAC, click **"Yes"**

### Step 3: Review Scan
The script will show you:
- How many tasks were found
- Which tasks are PROTECTED (won't be touched)
- Which tasks will be REMOVED

Example:
```
  [PROTECTED] \Microsoft\Windows\UpdateOrchestrator\Schedule Scan
  [REMOVING] \OpenClaw Gateway
```

### Step 4: Confirm
- Press **any key** to proceed with removal
- Or press **Ctrl+C** to cancel

### Step 5: Check Results
After completion, you'll see:
```
Tasks scanned: 245
Tasks protected: 218
Tasks removed: 27
```

### Step 6: Restart
Restart your PC for changes to take full effect.

## Where Are My Backups?

Two locations:
1. **Desktop**: `Task_Startup_Backup_YYYYMMDD_HHMMSS`
2. **Script folder**: `Backups\Backup_YYYYMMDD_HHMMSS`

Each contains:
- `Removed_Tasks.txt` - What was removed
- `How_To_Restore.txt` - How to restore
- `Summary.txt` - Statistics

## What If I Need Something Back?

### Option 1: Reinstall the App
Most apps recreate their tasks automatically.

### Option 2: Check If You Really Need It
Many removed tasks are just for:
- Auto-updates (can update manually)
- Telemetry (not needed)
- Background sync (app works fine without it)

### Option 3: Manual Restore
See `How_To_Restore.txt` in your backup folder.

## Common Questions

**Q: Will this break Windows?**  
A: No. All Windows system tasks are protected.

**Q: What if an app stops working?**  
A: Reinstall the app or check if it has a "run at startup" setting.

**Q: Can I run this multiple times?**  
A: Yes! Each run creates a new timestamped backup.

**Q: Do I need Registry Startup Cleaner too?**  
A: Yes! They clean different things:
- Registry Cleaner → Cleans registry Run keys
- Task Cleaner → Cleans scheduled tasks

## That's It!

You now have a cleaner, faster startup. 🚀

Need help? Open an issue on GitHub.
