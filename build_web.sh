#!/bin/bash

# Pet Adoption App - Web Build Script
# This script builds the app for web deployment

echo "🚀 Building Pet Adoption App for Web..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ This script must be run from the project root directory"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Create API keys file if it doesn't exist
if [ ! -f "lib/core/api/api_keys.dart" ]; then
    echo "🔑 Creating API keys file from example..."
    cp lib/core/api/api_keys.example.dart lib/core/api/api_keys.dart
    echo "⚠️  Please update lib/core/api/api_keys.dart with your actual API keys"
fi

# Generate code
echo "⚙️  Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Build for web
echo "🌐 Building for web..."
flutter build web --release --web-renderer html

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "📁 Web files are in: build/web/"
    echo ""
    echo "🚀 Ready for deployment!"
    echo "📖 See DEPLOYMENT.md for deployment instructions"
else
    echo "❌ Build failed!"
    exit 1
fi
