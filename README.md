# GeoSem - KNUST Geography Seminar Manager

A comprehensive Flutter application that wraps the React-based seminar management system for the KNUST Department of Geography and Rural Development.

## 🎓 Overview

GeoSem is a native Flutter application that provides a mobile-friendly wrapper around the existing React web application. It combines the power of native mobile development with the flexibility of web technologies.

## 🏗️ Architecture

### Flutter Shell (Native)
- **Platform**: Flutter (iOS, Android, Web, Desktop)
- **Purpose**: Native wrapper with KNUST branding
- **Features**: 
  - Native navigation and UI
  - WebView integration for React app
  - KNUST green and gold theme
  - Loading states and error handling

### React Web App (WebView Content)
- **Platform**: React with Material-UI
- **Purpose**: Core seminar management functionality
- **Features**:
  - User authentication and profiles
  - Seminar management and registration
  - Role-based dashboards (Admin, HOD, Senior Member, Student)
  - Notification system

## 🚀 Getting Started

### Prerequisites

1. **Flutter SDK** (>= 3.10.7)
2. **Node.js** (>= 16.0.0)
3. **npm** or **yarn**

### Installation

1. **Navigate to the GeoSem directory**:
   ```bash
   cd /home/echendaa/CascadeProjects/geosem
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Install React dependencies**:
   ```bash
   cd ../seminar_manager/seminar-manager
   npm install
   ```

### Running the Application

#### Option 1: Using the Automated Script (Recommended)

```bash
cd /home/echendaa/CascadeProjects/geosem
./run_geosem.sh
```

This script will:
- Start the React development server
- Wait for it to be ready
- Launch the Flutter app
- Handle cleanup when you stop the app

#### Option 2: Manual Setup

1. **Start the React development server**:
   ```bash
   cd /home/echendaa/CascadeProjects/seminar_manager/seminar-manager
   npm start
   ```

2. **In a new terminal, start the Flutter app**:
   ```bash
   cd /home/echendaa/CascadeProjects/geosem
   flutter run
   ```

## 🎨 KNUST Branding

The application features official KNUST colors:
- **Primary Green**: `#006633`
- **Accent Gold**: `#FFD700`

### UI Elements
- **App Bar**: KNUST green background with gold logo
- **Loading Screen**: Branded with KNUST colors and logo
- **Buttons**: KNUST green gradient
- **Typography**: Consistent with university branding

## 📱 Features

### Flutter Wrapper Features
- **Native Performance**: Smooth animations and transitions
- **Cross-Platform**: Works on iOS, Android, and desktop
- **Offline Support**: Basic caching capabilities
- **Native Integration**: Access to device features (camera, notifications, etc.)
- **KNUST Branding**: Professional university appearance

### React App Features
- **User Management**: Role-based authentication and profiles
- **Seminar Management**: Create, edit, and manage seminars
- **Registration System**: Student seminar registration
- **Dashboard**: Role-specific dashboards with analytics
- **Notifications**: Real-time updates and alerts
- **Profile Management**: Automatic profile creation for all user roles

## 🔧 Configuration

### WebView URL
The Flutter app is configured to load the React app from:
```
http://localhost:3000
```

To change this for production, update the URL in `/lib/main.dart`:
```dart
..loadRequest(
  Uri.parse('https://your-production-url.com'), // Change this URL
);
```

## 📂 Project Structure

```
geosem/
├── lib/
│   └── main.dart              # Main Flutter application
├── assets/
│   └── logo/
│       └── geosem_logo.png    # KNUST logo
├── pubspec.yaml               # Flutter dependencies
└── run_geosem.sh             # Automated launch script

../seminar_manager/seminar-manager/
├── src/                       # React source code
├── public/                    # React assets
└── package.json              # React dependencies
```

## 🛠️ Development

### Flutter Development
- **IDE**: VS Code, Android Studio, or IntelliJ
- **Hot Reload**: Enabled for rapid development
- **Debugging**: Flutter Inspector and DevTools

### React Development
- **IDE**: VS Code (recommended)
- **Hot Reload**: Enabled
- **Debugging**: React Developer Tools

## 📦 Building for Production

### Flutter App
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### React App
```bash
cd ../seminar_manager/seminar-manager
npm run build
```

## 📱 Supported Platforms

- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Web**: Modern browsers (Chrome, Firefox, Safari, Edge)
- **Desktop**: Windows, macOS, Linux

## 🤝 Contributing

1. Follow the KNUST coding standards
2. Maintain the official KNUST branding guidelines
3. Test on multiple platforms
4. Update documentation for any changes

## 📄 License

This project is the property of KNUST Department of Geography and Rural Development.

---

🎓 **Kwame Nkrumah University of Science and Technology**  
📍 **Department of Geography and Rural Development**
