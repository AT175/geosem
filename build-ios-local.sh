#!/bin/bash

# Free iOS Build Script - Uses Local Build
# This script builds iOS locally without GitHub Actions billing

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🎓 GeoSem Free iOS Build Script${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Not in GeoSem project directory${NC}"
    exit 1
fi

echo -e "${GREEN}✅ In GeoSem project directory${NC}"

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not installed${NC}"
    echo -e "${YELLOW}Please install Flutter first${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Flutter is installed${NC}"
flutter --version

# Check if we're on macOS (required for iOS builds)
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ iOS builds require macOS${NC}"
    echo -e "${YELLOW}This script only works on macOS with Xcode${NC}"
    echo ""
    echo -e "${BLUE}Alternative Options:${NC}"
    echo "1. Use Codemagic (free tier available)"
    echo "2. Use AppCircle (free tier available)"
    echo "3. Make GitHub repo public for free GitHub Actions"
    echo ""
    echo -e "${YELLOW}Would you like me to set up Codemagic instead?${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Running on macOS - iOS builds supported${NC}"

# Check Xcode installation
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ Xcode not installed${NC}"
    echo -e "${YELLOW}Please install Xcode from App Store${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Xcode is installed${NC}"
xcodebuild -version

# Check CocoaPods
if ! command -v pod &> /dev/null; then
    echo -e "${RED}❌ CocoaPods not installed${NC}"
    echo -e "${YELLOW}Installing CocoaPods...${NC}"
    sudo gem install cocoapods
fi

echo -e "${GREEN}✅ CocoaPods is installed${NC}"

# Start build process
echo -e "${BLUE}🚀 Starting iOS build process...${NC}"
echo ""

# Step 1: Get Flutter dependencies
echo -e "${YELLOW}📦 Installing Flutter dependencies...${NC}"
flutter pub get

# Step 2: Install CocoaPods dependencies
echo -e "${YELLOW}📦 Installing iOS dependencies...${NC}"
cd ios
pod install
cd ..

# Step 3: Build iOS app
echo -e "${YELLOW}🔨 Building iOS app...${NC}"
flutter build ios --release --no-codesign

echo -e "${GREEN}✅ iOS build completed successfully!${NC}"
echo ""

# Step 4: Create IPA (if codesigning is set up)
echo -e "${YELLOW}📱 Creating IPA file...${NC}"
cd ios
xcodebuild -workspace Runner.xcworkspace \
          -scheme Runner \
          -configuration Release \
          -archivePath build/Runner.xcarchive \
          archive

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Archive created successfully${NC}"
    
    # Export IPA (if ExportOptions.plist exists)
    if [ -f "ExportOptions.plist" ]; then
        xcodebuild -exportArchive \
                  -archivePath build/Runner.xcarchive \
                  -exportOptionsPlist ExportOptions.plist \
                  -exportPath build/outputs
        
        echo -e "${GREEN}✅ IPA file created!${NC}"
        echo -e "${YELLOW}📍 Location: ios/build/outputs/*.ipa${NC}"
    else
        echo -e "${YELLOW}⚠️  No ExportOptions.plist found - archive created but not exported${NC}"
        echo -e "${YELLOW}📍 Archive location: ios/build/Runner.xcarchive${NC}"
    fi
else
    echo -e "${RED}❌ Archive creation failed${NC}"
    exit 1
fi

cd ..

echo ""
echo -e "${BLUE}🎓 GeoSem iOS Build Summary${NC}"
echo -e "${BLUE}=============================${NC}"
echo -e "${GREEN}📱 Build Type: Local iOS Build${NC}"
echo -e "${GREEN}🎨 KNUST Branding: Included${NC}"
echo -e "${GREEN}🌐 React WebView: Integrated${NC}"
echo -e "${GREEN}⚡ Performance: Native iOS${NC}"
echo ""

if [ -f "ios/build/outputs/Runner.ipa" ]; then
    echo -e "${GREEN}📦 IPA File: ios/build/outputs/Runner.ipa${NC}"
    echo -e "${GREEN}✅ Ready for TestFlight or App Store${NC}"
else
    echo -e "${YELLOW}📦 Archive: ios/build/Runner.xcarchive${NC}"
    echo -e "${YELLOW}⚠️  Manual export required for IPA${NC}"
fi

echo ""
echo -e "${BLUE}🔗 Next Steps:${NC}"
echo "1. Install IPA on device via Xcode"
echo "2. Upload to TestFlight for beta testing"
echo "3. Submit to App Store for distribution"
