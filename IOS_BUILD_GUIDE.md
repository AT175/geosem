# GeoSem iOS Build Script

## 🎓 Automated iOS Building with GitHub Actions

This script provides a complete solution for building the GeoSem iOS app using GitHub Actions.

## 🚀 Quick Usage

### **Basic Build (Recommended)**
```bash
cd /home/echendaa/CascadeProjects/geosem
./build-ios.sh
```

### **Full Build Cycle**
```bash
./build-ios.sh all
```

## 📋 Available Commands

| Command | Description |
|---------|-------------|
| `./build-ios.sh` | Trigger build via git push (default) |
| `./build-ios.sh trigger-push` | Trigger build by pushing to GitHub |
| `./build-ios.sh trigger-dispatch` | Trigger build via workflow dispatch |
| `./build-ios.sh monitor` | Monitor current build progress |
| `./build-ios.sh download` | Download build artifacts |
| `./build-ios.sh all` | Full cycle: trigger → monitor → download |
| `./build-ios.sh help` | Show help message |

## 🎯 Features

### **1. Automated Build Triggers**
- 📤 **Git Push**: Triggers GitHub Actions automatically
- 🔄 **Workflow Dispatch**: Manual trigger with parameters
- 🏷️ **Tag Support**: Release builds for version tags

### **2. Build Monitoring**
- 📊 **Real-time Status**: Live build progress updates
- 🔗 **GitHub Integration**: Direct links to build logs
- ⏱️ **Progress Tracking**: Step-by-step build monitoring

### **3. Artifact Management**
- 📦 **Automatic Download**: Fetch IPA files and frameworks
- 📁 **Organized Storage**: Artifacts saved to `builds/` directory
- 🔍 **Build History**: Track multiple build versions

### **4. KNUST Integration**
- 🎨 **Branding**: KNUST green and gold theme
- 🏛️ **Department**: Geography and Rural Development
- 📱 **Professional**: University-standard app quality

## 🔧 Prerequisites

### **Required Tools**
```bash
# GitHub CLI (should already be installed)
gh --version

# Git (should already be configured)
git --version

# Flutter project (already set up)
ls pubspec.yaml ios/
```

### **Authentication**
```bash
# Verify GitHub authentication
gh auth status

# If not authenticated
gh auth login
```

## 📱 Build Process

### **What Happens When You Run the Script**

#### **1. Validation**
- ✅ Check GitHub CLI installation
- ✅ Verify GitHub authentication
- ✅ Confirm Flutter project structure

#### **2. Build Trigger**
- 📤 Push changes to GitHub (if needed)
- 🚀 Trigger GitHub Actions workflow
- 🔄 Start iOS build process

#### **3. Build Monitoring**
- 📊 Monitor build status in real-time
- 🔗 Provide GitHub Actions links
- ⏱️ Track progress through build steps

#### **4. Artifact Download**
- 📦 Download IPA files
- 📁 Save to `builds/` directory
- ✅ Verify download success

## 🎨 Build Outputs

### **iOS App Package**
- 📱 **IPA File**: Ready for TestFlight/App Store
- 🎨 **KNUST Branding**: Official colors and logo
- 🌐 **React WebView**: Seminar management system
- ⚡ **Performance**: Native iOS optimization

### **Build Artifacts**
- 📦 **Framework Files**: iOS frameworks
- 📊 **Build Logs**: Detailed build information
- 🔍 **Debug Symbols**: For debugging (if needed)

## 🚀 Example Workflows

### **Development Build**
```bash
# Quick development build
./build-ios.sh trigger-push
./build-ios.sh monitor
```

### **Release Build**
```bash
# Full release cycle
./build-ios.sh all
```

### **Monitoring Only**
```bash
# Check current build status
./build-ios.sh monitor
```

### **Download Artifacts**
```bash
# Get latest build files
./build-ios.sh download
```

## 📊 GitHub Actions Integration

### **Workflow Triggers**
- 📤 **Push**: Auto-build on code changes
- 🏷️ **Tags**: Release builds for versions
- 🔀 **Pull Requests**: Test builds before merge
- ⚡ **Manual**: On-demand builds

### **Build Environment**
- 🍎 **macOS**: Latest macOS with Xcode
- 📱 **Flutter**: Stable channel
- 📦 **Dependencies**: Automatic CocoaPods install
- 🔧 **Configuration**: KNUST-specific settings

### **Build Results**
- ✅ **Success**: IPA file ready for distribution
- ❌ **Failure**: Detailed error logs
- 📊 **Summary**: Build statistics and metrics

## 🔍 Troubleshooting

### **Common Issues**

#### **GitHub CLI Not Found**
```bash
# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh
gh auth login
```

#### **Authentication Failed**
```bash
# Re-authenticate
gh auth logout
gh auth login
```

#### **Build Fails**
```bash
# Check build logs
./build-ios.sh monitor

# View on GitHub
open https://github.com/AT175/geosem/actions
```

#### **Download Issues**
```bash
# Manually download artifacts
gh run list --repo AT175/geosem
gh run download <run-id> --repo AT175/geosem
```

## 🎓 KNUST-Specific Features

### **App Configuration**
- 📱 **Bundle ID**: `com.knust.geography.geosem`
- 🎨 **Colors**: KNUST green (#006633) and gold (#FFD700)
- 🏛️ **Branding**: Department of Geography and Rural Development
- 📝 **Metadata**: KNUST app store information

### **Build Optimization**
- ⚡ **Performance**: Optimized for iOS devices
- 📱 **Responsive**: Adapts to different screen sizes
- 🔒 **Security**: Code signing and protection
- 🌐 **WebView**: React seminar management system

## 📱 Distribution

### **TestFlight**
- 🧪 **Beta Testing**: Internal testing with KNUST staff
- 👥 **Test Groups**: Students, faculty, administrators
- 📊 **Feedback**: Collect user feedback

### **App Store**
- 🏪 **Public Distribution**: Available on App Store
- 📱 **Global Reach**: Accessible worldwide
- 📊 **Analytics**: Usage tracking and insights

---

**This script provides a complete solution for building and distributing the KNUST GeoSem iOS app!** 🎓📱✨
