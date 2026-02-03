#!/bin/bash

# GeoSem Flutter + React Integration Script
# This script sets up and runs the complete GeoSem application

echo "🎓 Starting GeoSem - KNUST Geography Seminar Manager"
echo "=================================================="

# Function to check if a port is in use
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null ; then
        echo "✅ Port $1 is in use"
        return 0
    else
        echo "❌ Port $1 is not in use"
        return 1
    fi
}

# Function to wait for a service to be ready
wait_for_service() {
    local port=$1
    local service_name=$2
    local max_attempts=30
    local attempt=1
    
    echo "⏳ Waiting for $service_name to be ready on port $port..."
    
    while [ $attempt -le $max_attempts ]; do
        if check_port $port; then
            echo "✅ $service_name is ready!"
            return 0
        fi
        
        echo "⏳ Attempt $attempt/$max_attempts: Waiting for $service_name..."
        sleep 2
        ((attempt++))
    done
    
    echo "❌ $service_name failed to start within expected time"
    return 1
}

# Check if required directories exist
if [ ! -d "/home/echendaa/CascadeProjects/seminar_manager" ]; then
    echo "❌ React seminar manager directory not found!"
    exit 1
fi

if [ ! -d "/home/echendaa/CascadeProjects/geosem" ]; then
    echo "❌ Flutter GeoSem directory not found!"
    exit 1
fi

echo "📁 Found required directories"
echo ""

# Start React development server
echo "🚀 Starting React development server..."
cd /home/echendaa/CascadeProjects/seminar_manager/seminar-manager

# Check if node_modules exists, if not install dependencies
if [ ! -d "node_modules" ]; then
    echo "📦 Installing React dependencies..."
    npm install
fi

# Start React app in background
echo "🌐 Starting React app on http://localhost:3000"
npm start &
REACT_PID=$!

# Wait for React server to be ready
if wait_for_service 3000 "React Development Server"; then
    echo "✅ React server is running successfully"
else
    echo "❌ Failed to start React server"
    kill $REACT_PID 2>/dev/null
    exit 1
fi

# Start Flutter app
echo "📱 Starting Flutter GeoSem app..."
cd /home/echendaa/CascadeProjects/geosem

# Check if Flutter dependencies are installed
if [ ! -d ".dart_tool" ]; then
    echo "📦 Installing Flutter dependencies..."
    flutter pub get
fi

echo "🚀 Launching Flutter app..."
echo "📱 GeoSem will open in a new window"
echo "🔗 React app is running at: http://localhost:3000"
echo ""
echo "🎓 GeoSem - KNUST Geography Seminar Manager"
echo "=================================================="
echo "💡 Tips:"
echo "   • The Flutter app provides a native wrapper around the React web app"
echo "   • Use the refresh button in the Flutter app to reload the React content"
echo "   • Press Ctrl+C in this terminal to stop both servers"
echo ""

# Start Flutter app
flutter run

# Cleanup function
cleanup() {
    echo ""
    echo "🛑 Shutting down servers..."
    
    # Kill React server
    if [ ! -z "$REACT_PID" ]; then
        echo "🛑 Stopping React server (PID: $REACT_PID)..."
        kill $REACT_PID 2>/dev/null
    fi
    
    # Kill any remaining processes on port 3000
    pkill -f "npm start" 2>/dev/null
    pkill -f "react-scripts" 2>/dev/null
    
    echo "✅ All servers stopped"
    echo "👋 Thank you for using GeoSem!"
}

# Set up cleanup on script exit
trap cleanup EXIT

# Wait for user to stop the app
wait
