#!/bin/bash

# GeoSem iOS Build Script for GitHub Actions
# This script triggers and monitors iOS builds on GitHub

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
GITHUB_REPO="AT175/geosem"
GITHUB_API="https://api.github.com"
WORKFLOW_FILE="build-ios.yml"

echo -e "${BLUE}🎓 GeoSem iOS Build Script${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""

# Function to check if GitHub CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        echo -e "${RED}❌ GitHub CLI (gh) is not installed${NC}"
        echo -e "${YELLOW}Please install GitHub CLI first:${NC}"
        echo "curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg"
        echo "echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null"
        echo "sudo apt update && sudo apt install gh"
        echo "gh auth login"
        exit 1
    fi
    echo -e "${GREEN}✅ GitHub CLI is installed${NC}"
}

# Function to check GitHub authentication
check_auth() {
    if ! gh auth status &> /dev/null; then
        echo -e "${RED}❌ Not authenticated with GitHub${NC}"
        echo -e "${YELLOW}Please run: gh auth login${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Authenticated with GitHub${NC}"
}

# Function to check if we're in the right directory
check_directory() {
    if [ ! -f "pubspec.yaml" ] || [ ! -d "ios" ]; then
        echo -e "${RED}❌ Not in GeoSem Flutter project directory${NC}"
        echo -e "${YELLOW}Please run this script from the GeoSem project root${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ In correct GeoSem project directory${NC}"
}

# Function to trigger iOS build via push
trigger_build_push() {
    echo -e "${BLUE}🚀 Triggering iOS build via Git push...${NC}"
    
    # Check if there are changes to commit
    if [ -n "$(git status --porcelain)" ]; then
        echo -e "${YELLOW}📝 Found uncommitted changes, committing first...${NC}"
        git add .
        git commit -m "Trigger iOS build - $(date '+%Y-%m-%d %H:%M:%S')"
    fi
    
    # Push to trigger GitHub Actions
    echo -e "${BLUE}📤 Pushing to GitHub to trigger build...${NC}"
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Push successful - iOS build triggered!${NC}"
    else
        echo -e "${RED}❌ Push failed${NC}"
        exit 1
    fi
}

# Function to trigger build via workflow dispatch
trigger_build_dispatch() {
    echo -e "${BLUE}🚀 Triggering iOS build via workflow dispatch...${NC}"
    
    # Get workflow ID
    WORKFLOW_ID=$(gh api repos/$GITHUB_REPO/actions/workflows | jq -r ".workflows[] | select(.path == \"$WORKFLOW_FILE\") | .id")
    
    if [ -z "$WORKFLOW_ID" ]; then
        echo -e "${RED}❌ iOS workflow not found: $WORKFLOW_FILE${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Found iOS workflow ID: $WORKFLOW_ID${NC}"
    
    # Trigger workflow
    gh api --method POST repos/$GITHUB_REPO/actions/workflows/$WORKFLOW_ID/dispatches \
        --field ref=main \
        --field inputs='{"build_type": "release", "trigger": "manual_script"}'
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Workflow dispatch successful!${NC}"
    else
        echo -e "${RED}❌ Workflow dispatch failed${NC}"
        exit 1
    fi
}

# Function to monitor build progress
monitor_build() {
    echo -e "${BLUE}📊 Monitoring iOS build progress...${NC}"
    echo ""
    
    # Get the latest workflow run
    echo -e "${YELLOW}⏳ Waiting for workflow to start...${NC}"
    sleep 5
    
    # Get workflow run ID
    RUN_ID=$(gh api repos/$GITHUB_REPO/actions/runs --jq ".workflow_runs[0].id")
    RUN_STATUS=$(gh api repos/$GITHUB_REPO/actions/runs/$RUN_ID --jq ".status")
    RUN_CONCLUSION=$(gh api repos/$GITHUB_REPO/actions/runs/$RUN_ID --jq ".conclusion")
    
    echo -e "${GREEN}📱 Build started! Run ID: $RUN_ID${NC}"
    echo -e "${BLUE}🔗 View on GitHub: https://github.com/$GITHUB_REPO/actions/runs/$RUN_ID${NC}"
    echo ""
    
    # Monitor progress
    while [ "$RUN_STATUS" != "completed" ]; do
        RUN_STATUS=$(gh api repos/$GITHUB_REPO/actions/runs/$RUN_ID --jq ".status")
        echo -e "${YELLOW}⏳ Build status: $RUN_STATUS${NC}"
        sleep 10
    done
    
    # Get final result
    RUN_CONCLUSION=$(gh api repos/$GITHUB_REPO/actions/runs/$RUN_ID --jq ".conclusion")
    
    if [ "$RUN_CONCLUSION" = "success" ]; then
        echo -e "${GREEN}🎉 iOS build completed successfully!${NC}"
        echo -e "${GREEN}📱 IPA file is ready for download${NC}"
    else
        echo -e "${RED}❌ iOS build failed: $RUN_CONCLUSION${NC}"
        echo -e "${BLUE}🔗 View logs: https://github.com/$GITHUB_REPO/actions/runs/$RUN_ID${NC}"
        exit 1
    fi
}

# Function to download build artifacts
download_artifacts() {
    echo -e "${BLUE}📦 Downloading build artifacts...${NC}"
    
    # Get the latest successful run
    RUN_ID=$(gh api repos/$GITHUB_REPO/actions/runs --jq ".workflow_runs[] | select(.conclusion == \"success\") | .id" | head -1)
    
    if [ -z "$RUN_ID" ]; then
        echo -e "${RED}❌ No successful builds found${NC}"
        return 1
    fi
    
    # List artifacts
    ARTIFACTS=$(gh api repos/$GITHUB_REPO/actions/runs/$RUN_ID/artifacts --jq ".artifacts[].name")
    
    echo -e "${GREEN}📋 Available artifacts:${NC}"
    echo "$ARTIFACTS"
    
    # Download artifacts
    mkdir -p builds
    for artifact in $ARTIFACTS; do
        echo -e "${BLUE}📥 Downloading $artifact...${NC}"
        gh api repos/$GITHUB_REPO/actions/artifacts/$artifact/zip --output "builds/$artifact.zip"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Downloaded: builds/$artifact.zip${NC}"
        else
            echo -e "${RED}❌ Failed to download $artifact${NC}"
        fi
    done
    
    echo -e "${GREEN}📦 All artifacts downloaded to builds/ directory${NC}"
}

# Function to show build summary
show_summary() {
    echo ""
    echo -e "${BLUE}🎓 GeoSem iOS Build Summary${NC}"
    echo -e "${BLUE}=============================${NC}"
    echo -e "${GREEN}📱 Repository: $GITHUB_REPO${NC}"
    echo -e "${GREEN}🎨 KNUST Branding: Included${NC}"
    echo -e "${GREEN}🌐 React WebView: Integrated${NC}"
    echo -e "${GREEN}📦 Build Type: Release${NC}"
    echo ""
    echo -e "${BLUE}🔗 GitHub Repository: https://github.com/$GITHUB_REPO${NC}"
    echo -e "${BLUE}📊 Actions Dashboard: https://github.com/$GITHUB_REPO/actions${NC}"
    echo ""
}

# Function to show usage
show_usage() {
    echo -e "${BLUE}Usage: $0 [OPTION]${NC}"
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "  trigger-push     Trigger build via git push (default)"
    echo "  trigger-dispatch Trigger build via workflow dispatch"
    echo "  monitor          Monitor current build progress"
    echo "  download         Download build artifacts"
    echo "  all              Trigger, monitor, and download"
    echo "  help             Show this help message"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  $0                # Trigger build via push"
    echo "  $0 all            # Full build cycle"
    echo "  $0 monitor        # Monitor current build"
    echo ""
}

# Main script logic
main() {
    # Check prerequisites
    check_gh_cli
    check_auth
    check_directory
    
    # Parse command line arguments
    case "${1:-trigger-push}" in
        "trigger-push")
            trigger_build_push
            ;;
        "trigger-dispatch")
            trigger_build_dispatch
            ;;
        "monitor")
            monitor_build
            ;;
        "download")
            download_artifacts
            ;;
        "all")
            trigger_build_push
            monitor_build
            download_artifacts
            ;;
        "help"|"-h"|"--help")
            show_usage
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
    
    # Show summary
    show_summary
}

# Run main function
main "$@"
