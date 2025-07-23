# Contributing to Pet Adoption App

First off, thank you for considering contributing to Pet Adoption App! It's people like you that make this project great.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to see if the problem has already been reported. When you are creating a bug report, please include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples to demonstrate the steps**
- **Describe the behavior you observed after following the steps**
- **Explain which behavior you expected to see instead and why**
- **Include screenshots and animated GIFs if helpful**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- **Use a clear and descriptive title**
- **Provide a step-by-step description of the suggested enhancement**
- **Provide specific examples to demonstrate the steps**
- **Describe the current behavior and explain which behavior you expected to see instead**
- **Explain why this enhancement would be useful**

### Pull Requests

1. Fork the repo and create your branch from `main`
2. If you've added code that should be tested, add tests
3. If you've changed APIs, update the documentation
4. Ensure the test suite passes
5. Make sure your code lints
6. Issue that pull request!

## Development Setup

1. **Clone your fork**
   ```bash
   git clone https://github.com/yourusername/pet_adoption_app.git
   cd pet_adoption_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up API keys**
   - Copy `lib/core/api/api_keys.example.dart` to `lib/core/api/api_keys.dart`
   - Add your actual API keys from The Cat API and The Dog API

4. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run tests**
   ```bash
   flutter test
   ```

## Style Guidelines

### Dart Style Guide

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format your code
- Use meaningful variable and function names
- Add documentation comments for public APIs

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

### Flutter/Dart Specific

- Follow the official [Flutter style guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- Use `const` constructors where possible
- Prefer `final` over `var` when the variable won't be reassigned
- Use trailing commas for better formatting
- Group imports: dart, flutter, packages, relative

### Architecture Guidelines

This project follows Clean Architecture principles:

- **Domain Layer**: Contains business entities, repository interfaces, and use cases
- **Data Layer**: Contains repository implementations, data sources, and models
- **Presentation Layer**: Contains UI components, BLoC, and screens

When adding new features:
- Start with the domain layer (entities, repositories, use cases)
- Implement the data layer (models, data sources, repository implementations)
- Finally, implement the presentation layer (UI, BLoC)

## Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Write integration tests for user flows
- Aim for good test coverage but focus on critical paths

## Documentation

- Update the README.md if you change functionality
- Add inline documentation for complex logic
- Update API documentation if you change interfaces

Thank you for contributing! 🎉
