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

## 📱 Screenshots

> Add your app screenshots here

## 🚀 Getting Started

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

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
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

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [The Cat API](https://thecatapi.com/) for providing cat data
- [The Dog API](https://thedogapi.com/) for providing dog data
- Flutter team for the amazing framework
- All contributors who help improve this project

## 📞 Support

If you have any questions or issues, please open an issue on GitHub or contact [your-email@example.com](mailto:your-email@example.com).

---

Made with ❤️ and Flutter
# Pet_adoption_app
