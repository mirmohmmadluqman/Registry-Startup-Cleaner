# Repository Structure Guide

This document explains the complete file structure for the Registry Startup Cleaner GitHub repository.

## 📁 Complete Directory Structure

```
registry-startup-cleaner/
│
├── .github/
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md
│       └── feature_request.md
│
├── docs/
│   ├── images/
│   │   └── screenshot.png (optional - add your screenshots)
│   └── FAQ.md
│
├── Backups/                     (Created automatically by script)
│   └── .gitkeep                 (Keeps folder in git)
│
├── RegistryStartupCleaner.bat   (Main script)
├── README.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
├── .gitignore
└── .gitattributes               (Optional)
```

## 📄 File Descriptions

### Root Files

#### `RegistryStartupCleaner.bat`
- **Type**: Main executable script
- **Purpose**: The core batch file that performs registry scanning and cleaning
- **Size**: ~8KB
- **Required**: Yes

#### `README.md`
- **Type**: Documentation
- **Purpose**: Main project documentation with usage instructions
- **Required**: Yes
- **Contains**: Features, installation, usage, examples

#### `LICENSE`
- **Type**: Legal document
- **Purpose**: MIT License defining terms of use
- **Required**: Yes

#### `CHANGELOG.md`
- **Type**: Documentation
- **Purpose**: Version history and changes
- **Required**: Recommended

#### `CONTRIBUTING.md`
- **Type**: Documentation
- **Purpose**: Guidelines for contributors
- **Required**: Recommended

#### `SECURITY.md`
- **Type**: Documentation
- **Purpose**: Security policy and vulnerability reporting
- **Required**: Recommended

#### `.gitignore`
- **Type**: Git configuration
- **Purpose**: Specifies which files Git should ignore
- **Required**: Yes

#### `.gitattributes` (Optional)
- **Type**: Git configuration
- **Purpose**: Ensures consistent line endings across platforms
- **Required**: No

### .github Folder

#### `ISSUE_TEMPLATE/bug_report.md`
- **Type**: GitHub template
- **Purpose**: Standardized bug report format
- **Required**: Recommended

#### `ISSUE_TEMPLATE/feature_request.md`
- **Type**: GitHub template
- **Purpose**: Standardized feature request format
- **Required**: Recommended

### docs Folder (Optional)

#### `FAQ.md`
- **Type**: Documentation
- **Purpose**: Frequently Asked Questions
- **Required**: Optional

#### `images/`
- **Type**: Directory
- **Purpose**: Store screenshots and images for documentation
- **Required**: Optional

### Backups Folder

#### Automatically Created
- **Type**: Directory
- **Purpose**: Stores local backups created by the script
- **Note**: Excluded from Git via `.gitignore`

## 🚀 Repository Setup Steps

### Step 1: Create Repository on GitHub

1. Go to GitHub.com
2. Click "New Repository"
3. Repository name: `registry-startup-cleaner`
4. Description: "Windows batch script to safely backup and remove unwanted startup programs from registry"
5. Choose: Public or Private
6. ✅ Add README file (we'll replace it)
7. ✅ Choose MIT License
8. ❌ Don't add .gitignore (we have custom one)

### Step 2: Clone Repository Locally

```bash
git clone https://github.com/mirmohmmadluqman/registry-startup-cleaner.git
cd registry-startup-cleaner
```

### Step 3: Create Directory Structure

```bash
# Windows Command Prompt
mkdir .github\ISSUE_TEMPLATE
mkdir docs\images
mkdir Backups
echo. > Backups\.gitkeep

# PowerShell
New-Item -ItemType Directory -Path ".github\ISSUE_TEMPLATE"
New-Item -ItemType Directory -Path "docs\images"
New-Item -ItemType Directory -Path "Backups"
New-Item -ItemType File -Path "Backups\.gitkeep"
```

### Step 4: Add All Files

Copy all the files I've created into their respective locations:

```
registry-startup-cleaner/
├── RegistryStartupCleaner.bat
├── README.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
├── .gitignore
├── .github/
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md
│       └── feature_request.md
└── Backups/
    └── .gitkeep
```

### Step 5: Initial Commit

```bash
git add .
git commit -m "Initial commit: Registry Startup Cleaner v1.0.0"
git push origin main
```

## 📋 File Checklist

Before pushing to GitHub, ensure you have:

- [x] `RegistryStartupCleaner.bat` - Main script
- [x] `README.md` - Project documentation
- [x] `LICENSE` - MIT License
- [x] `CHANGELOG.md` - Version history
- [x] `CONTRIBUTING.md` - Contribution guidelines
- [x] `SECURITY.md` - Security policy
- [x] `.gitignore` - Git ignore rules
- [x] `.github/ISSUE_TEMPLATE/bug_report.md` - Bug report template
- [x] `.github/ISSUE_TEMPLATE/feature_request.md` - Feature request template
- [x] `Backups/.gitkeep` - Keeps Backups folder in Git

## 🎨 Optional Enhancements

### Add Badges to README

```markdown
![Version](https://img.shields.io/badge/version-1.0-blue)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)
![Stars](https://img.shields.io/github/stars/mirmohmmadluqman/registry-startup-cleaner)
```

### Add GitHub Topics

Add these topics to your repository:
- `windows`
- `registry`
- `startup`
- `batch-script`
- `cleaner`
- `backup`
- `automation`

### Create Releases

After your first commit:
1. Go to "Releases" → "Create a new release"
2. Tag: `v1.0.0`
3. Title: "Registry Startup Cleaner v1.0.0"
4. Description: Copy from CHANGELOG.md
5. Attach `RegistryStartupCleaner.bat` as binary

## 📊 Repository Settings

### Settings → General
- ✅ Enable Issues
- ✅ Enable Wiki (optional)
- ❌ Disable Projects (unless needed)

### Settings → Options
- Default branch: `main`
- ✅ Automatically delete head branches

### Settings → Security
- ✅ Enable Dependabot alerts (if applicable)
- ✅ Enable security advisories

## 🔄 Maintenance

### Regular Updates
1. Keep CHANGELOG.md updated
2. Respond to issues promptly
3. Review and merge pull requests
4. Update version numbers consistently

### Version Numbering
Follow Semantic Versioning (semver):
- `1.0.0` - Major.Minor.Patch
- Increment MAJOR for breaking changes
- Increment MINOR for new features
- Increment PATCH for bug fixes

## 📱 Social Preview

Create a social preview image:
- Size: 1280x640 pixels
- Include: Project name and brief description
- Upload in: Settings → General → Social Preview

---

**Ready to Deploy**: Once all files are in place, your repository is ready to go live!