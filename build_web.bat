@echo off
REM Pet Adoption App - Web Build Script for Windows
REM This script builds the app for web deployment

echo 🚀 Building Pet Adoption App for Web...

REM Check if Flutter is installed
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed or not in PATH
    exit /b 1
)

REM Check if we're in the right directory
if not exist "pubspec.yaml" (
    echo ❌ This script must be run from the project root directory
    exit /b 1
)

REM Clean previous builds
echo 🧹 Cleaning previous builds...
flutter clean

REM Get dependencies
echo 📦 Getting dependencies...
flutter pub get

REM Create API keys file if it doesn't exist
if not exist "lib\core\api\api_keys.dart" (
    echo 🔑 Creating API keys file from example...
    copy "lib\core\api\api_keys.example.dart" "lib\core\api\api_keys.dart"
    echo ⚠️  Please update lib\core\api\api_keys.dart with your actual API keys
)

REM Generate code
echo ⚙️  Generating code...
flutter packages pub run build_runner build --delete-conflicting-outputs

REM Build for web
echo 🌐 Building for web...
flutter build web --release --web-renderer html

REM Check if build was successful
if %errorlevel% equ 0 (
    echo ✅ Build successful!
    echo 📁 Web files are in: build\web\
    echo.
    echo 🚀 Ready for deployment!
    echo 📖 See DEPLOYMENT.md for deployment instructions
) else (
    echo ❌ Build failed!
    exit /b 1
)
