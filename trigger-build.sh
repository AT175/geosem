#!/bin/bash

# Simple iOS Build Trigger - Git Only Version
# Triggers GitHub Actions build without GitHub CLI

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🎓 GeoSem iOS Build Trigger${NC}"
echo -e "${BLUE}========================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Not in GeoSem project directory${NC}"
    exit 1
fi

echo -e "${GREEN}✅ In GeoSem project directory${NC}"

# Check Git remote
if ! git remote get-url origin >/dev/null 2>&1; then
    echo -e "${RED}❌ Git remote not found${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Git remote configured${NC}"
git remote -v

# Create build trigger
echo -e "${BLUE}🚀 Triggering iOS build...${NC}"

# Add a small change to trigger build
echo "# iOS Build Trigger - $(date)" >> BUILD_TRIGGERS.md
git add BUILD_TRIGGERS.md
git commit -m "Trigger iOS build - $(date '+%Y-%m-%d %H:%M:%S')"

# Push to trigger GitHub Actions
echo -e "${BLUE}📤 Pushing to GitHub...${NC}"
git push origin main

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build triggered successfully!${NC}"
    echo ""
    echo -e "${BLUE}🔗 Monitor build at:${NC}"
    echo -e "${YELLOW}https://github.com/AT175/geosem/actions${NC}"
    echo ""
    echo -e "${BLUE}⏱️  Build will take 10-15 minutes${NC}"
else
    echo -e "${RED}❌ Push failed${NC}"
    exit 1
fi
