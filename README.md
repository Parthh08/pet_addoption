# Pet Adoption App 🐾

A beautiful and feature-rich pet adoption app built with Flutter that allows users to browse, search, favorite, and adopt pets. The app follows clean architecture principles and implements modern Flutter development practices.

## 🌐 **LIVE DEMO**
**🎉 App is now deployed and live!** Try it out at your deployed URL.

[![Deploy Status](spectacular-muffin-e834bb.netlify.app)
[![Flutter](https://img.shields.io/badge/Flutter-3.19.0-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## ✨ Features

### Core Functionality
- 🏠 **Home Page**: Browse pets with search functionality and pagination
- 📱 **Pet Details**: Detailed view with image zoom and adoption capabilities
- ❤️ **Favorites**: Save and manage favorite pets
- 📜 **History**: Track adoption history with timeline view
- 🔍 **Search**: Search pets by name or breed
- 🎉 **Animations**: Hero animations, confetti effects, and smooth transitions

### Technical Features
- 🌙 **Dark Theme Support**: Automatic system theme detection
- 💾 **Offline Storage**: Persistent data using SharedPreferences and Hive
- 🔄 **Pull to Refresh**: Refresh pet listings
- 📱 **Responsive Design**: Adapts to different screen sizes
- 🧪 **Comprehensive Testing**: Unit, Widget, and Integration tests
- 🏗️ **Clean Architecture**: Domain-driven design with BLoC pattern

## 🏛️ Architecture

The app follows Clean Architecture principles with three main layers:

### Domain Layer
- **Entities**: Core business objects (Pet, AdoptionHistory)
- **Repositories**: Abstract contracts for data access
- **Use Cases**: Business logic and application workflows

### Data Layer
- **Models**: Data transfer objects with JSON serialization
- **Repositories**: Implementation of domain contracts
- **Data Sources**: Remote (API) and Local (SharedPreferences) data sources

### Presentation Layer
- **Pages**: UI screens (Home, Details, Favorites, History)
- **Widgets**: Reusable UI components
- **BLoC**: State management using the BLoC pattern

## 🛠️ Technology Stack

- **Framework**: Flutter 3.7.2+
- **State Management**: BLoC Pattern with flutter_bloc
- **Navigation**: GoRouter for declarative routing
- **HTTP Client**: Dio for API requests
- **Local Storage**: SharedPreferences and Hive
- **Image Handling**: cached_network_image with PhotoView
- **Dependency Injection**: GetIt service locator
- **JSON Serialization**: json_annotation & json_serializable
- **Testing**: flutter_test, bloc_test, mocktail

## 📱 Screenshots

### Home Page
- Pet listing with search functionality
- Hero animations for smooth navigation
- Pull-to-refresh support

### Details Page
- Full-screen image viewer with zoom
- Pet information and adoption button
- Confetti animation on adoption

### Favorites Page
- Saved favorite pets
- Quick adoption from favorites

### History Page
- Chronological adoption timeline
- Detailed adoption records

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.7.2 or higher
- Dart SDK 2.19.0 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pet_addoption
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### API Configuration
The app uses public APIs for pet data:
- **Cat API**: https://api.thecatapi.com/v1/
- **Dog API**: https://api.thedogapi.com/v1/

No API key is required for basic functionality, but you can add one in `lib/core/constants/app_constants.dart` for higher rate limits.

## 🧪 Testing

The app includes comprehensive testing coverage:

### Unit Tests
```bash
flutter test test/domain/
```

### Widget Tests
```bash
flutter test test/presentation/
```

### BLoC Tests
```bash
flutter test test/presentation/bloc/
```

### Integration Tests
```bash
flutter test integration_test/
```

### Run All Tests
```bash
flutter test
```

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── theme/              # Theme configuration
│   ├── router/             # Navigation setup
│   └── di/                 # Dependency injection
├── data/
│   ├── datasources/        # Remote and local data sources
│   ├── models/             # Data models with JSON serialization
│   └── repositories/       # Repository implementations
├── domain/
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository contracts
│   └── usecases/           # Business logic
└── presentation/
    ├── bloc/               # BLoC state management
    ├── pages/              # UI screens
    └── widgets/            # Reusable UI components
```

## 🎨 Design Principles

### UI/UX
- **Material Design 3**: Modern Flutter theming
- **Responsive Layout**: Adapts to different screen sizes
- **Smooth Animations**: Hero animations and micro-interactions
- **Accessibility**: Proper semantic labels and contrast ratios

### Code Quality
- **SOLID Principles**: Maintainable and extensible code
- **Clean Code**: Readable and well-documented
- **Type Safety**: Null safety and strong typing
- **Error Handling**: Graceful error states and user feedback

## 🔄 State Management

The app uses the BLoC (Business Logic Component) pattern for state management:

- **PetBloc**: Manages pet listing, search, and adoption
- **FavoritesBloc**: Handles favorite pets
- **HistoryBloc**: Manages adoption history

Each BLoC follows the principles of:
- **Separation of Concerns**: UI and business logic are separate
- **Testability**: Easy to unit test business logic
- **Reactive Programming**: Stream-based state updates

## 📊 Performance Optimizations

- **Image Caching**: Efficient image loading with cached_network_image
- **Lazy Loading**: Pagination for large pet lists
- **Memory Management**: Proper disposal of resources
- **Build Optimizations**: Const constructors and efficient widgets

## 🛡️ Error Handling

- **Network Errors**: Graceful handling of API failures
- **User Feedback**: Clear error messages and retry options
- **Offline Support**: Cached data when network is unavailable
- **Loading States**: Proper loading indicators

## 🔮 Future Enhancements

- [ ] **Push Notifications**: Adoption reminders and new pet alerts
- [ ] **User Authentication**: Personal profiles and cloud sync
- [ ] **Advanced Filters**: Filter by age, size, breed, location
- [ ] **Social Features**: Share pets and adoption stories
- [ ] **Map Integration**: Find nearby pets and shelters
- [ ] **Multi-language Support**: Internationalization

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📞 Support

If you have any questions or need help, please:
1. Check the [Issues](../../issues) page
2. Create a new issue with detailed information
3. Contact the development team

## 🙏 Acknowledgments

- **Cat API** and **Dog API** for providing pet data
- **Flutter Community** for excellent packages and resources
- **Material Design** for design inspiration
- **Contributors** who helped improve this project

---

**Made with ❤️ and Flutter** 🐾

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
