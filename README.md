# 🐱🐶 Pet Adoption App

A beautiful and modern Flutter application that helps users find and adopt their perfect furry companion. Built with clean architecture principles and modern Flutter practices.

## ✨ Features

- **Browse Pets**: Discover cats and dogs available for adoption
- **Search & Filter**: Find pets by breed, age, and other criteria
- **Favorites**: Save pets you're interested in for later viewing
- **Pet Details**: View comprehensive information about each pet
- **Cross-Platform**: Works on Android, iOS, and Web
- **Offline Support**: Cache pet data for offline browsing
- **Beautiful UI**: Modern, intuitive design with smooth animations

## 🛠️ Tech Stack

- **Framework**: Flutter 3.16.0+
- **Language**: Dart
- **State Management**: BLoC (Business Logic Component)
- **Architecture**: Clean Architecture with Domain-Driven Design
- **Navigation**: GoRouter
- **Networking**: Dio with caching support
- **Local Storage**: Hive for caching and favorites
- **Dependency Injection**: GetIt with Injectable
- **API Integration**: The Cat API & The Dog API


## � Download APK

You can download the latest Android APK directly from this repository:

- **[Download Pet Adoption App APK](./app-release.apk)** 📱

Simply download the APK file and install it on your Android device to start using the app right away!

> **Note**: Make sure to enable "Install from unknown sources" in your Android settings if prompted.

## �🚀 Getting Started

### Prerequisites

- Flutter SDK (3.16.0 or higher)
- Dart SDK (3.3.4 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/pet_adoption_app.git
   cd pet_adoption_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Set up API Keys**

   - Create an account at [The Cat API](https://thecatapi.com/) and [The Dog API](https://thedogapi.com/)
   - Create a file `lib/core/api/api_keys.dart` with your API keys:

   ```dart
   const String theCatApiKey = 'your_cat_api_key_here';
   const String theDogApiKey = 'your_dog_api_key_here';
   ```

4. **Generate code**

   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the app**

   ```bash
   # For development
   flutter run

   # For Android
   flutter run -d android

   # For iOS
   flutter run -d ios

   # For Web
   flutter run -d chrome
   ```

## 🏗️ Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── api/                # API configuration and keys
│   ├── config/             # App configuration
│   ├── di/                 # Dependency injection
│   ├── navigation/         # Navigation setup
│   └── utils/              # Utility functions
├── data/                   # Data layer
│   ├── datasources/        # Local and remote data sources
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── domain/                 # Domain layer
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business logic
└── presentation/           # Presentation layer
    ├── common_widgets/     # Reusable widgets
    ├── details/            # Pet details screen
    ├── favorites/          # Favorites screen
    ├── history/            # History screen
    └── home/               # Home screen
```

## 🔧 Build & Deploy

### Quick Download

- **Pre-built APK**: Download the ready-to-install APK from the root folder: `app-release.apk`

### Build from Source

#### Android APK

```bash
flutter build apk --release
```

#### Android App Bundle

```bash
flutter build appbundle --release
```

#### iOS

```bash
flutter build ios --release
```

#### Web

```bash
flutter build web --release
```

### Live Demo

- **Web Version**: [View Live App](https://petadoption92472.netlify.app/#/home) 🌐

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

```

## 📦 Dependencies

### Main Dependencies

- `flutter_bloc` - State management
- `dio` - HTTP client
- `cached_network_image` - Image caching
- `hive` - Local storage
- `go_router` - Navigation
- `get_it` & `injectable` - Dependency injection
- `equatable` - Value equality

### Dev Dependencies

- `flutter_test` - Testing framework
- `build_runner` - Code generation
- `json_annotation` - JSON serialization
- `mocktail` - Mocking for tests

## 🙏 Acknowledgments

- [The Cat API](https://thecatapi.com/) for providing cat data
- [The Dog API](https://thedogapi.com/) for providing dog data
- Flutter team for the amazing framework
- All contributors who help improve this project

---

Made with ❤️ and Flutter

# Pet_adoption_app
