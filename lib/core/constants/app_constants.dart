class AppConstants {
  // API Constants
  static const String baseUrl = 'https://api.thecatapi.com/v1/';
  static const String dogApiUrl = 'https://api.thedogapi.com/v1/';
  static const String apiKey = 'live_api_key'; 

  // Local Storage Keys
  static const String adoptedPetsKey = 'adopted_pets';
  static const String favoritePetsKey = 'favorite_pets';
  static const String adoptionHistoryKey = 'adoption_history';
  static const String themeKey = 'theme_mode';

  // App Info
  static const String appName = 'Pet Adoption';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int pageSize = 15;
  static const int initialPageSize = 10;
  static const int initialPage = 0;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardElevation = 4.0;
  static const double borderRadius = 12.0;

  // Animation Duration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration confettiDuration = Duration(seconds: 3);
}
