import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pet_addoption/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pet Adoption App Integration Tests', () {
    testWidgets('should navigate through all main screens', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify home screen is displayed
      expect(find.text('Pet Adoption'), findsOneWidget);

      // Navigate to favorites
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();

      // Verify favorites screen
      expect(find.text('Favorite Pets'), findsOneWidget);

      // Navigate to history
      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      // Verify history screen
      expect(find.text('Adoption History'), findsOneWidget);

      // Navigate back to home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      // Verify we're back at home
      expect(find.text('Pet Adoption'), findsOneWidget);
    });

    testWidgets('should search for pets', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Find the search field
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      // Enter search text
      await tester.enterText(searchField, 'golden');
      await tester.pumpAndSettle();

      // Wait for search results (this might take time due to API calls)
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('should handle favorite toggle', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for pets to load
      await tester.pump(const Duration(seconds: 3));

      // Find and tap a favorite button (heart icon)
      final favoriteButtons = find.byIcon(Icons.favorite_border);
      if (favoriteButtons.evaluate().isNotEmpty) {
        await tester.tap(favoriteButtons.first);
        await tester.pumpAndSettle();

        // Navigate to favorites to verify
        await tester.tap(find.text('Favorites'));
        await tester.pumpAndSettle();

        // Should have at least one favorite pet now
        expect(find.text('No favorites yet'), findsNothing);
      }
    });
  });
}
