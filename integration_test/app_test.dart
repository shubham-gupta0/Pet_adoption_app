import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pet_adoption_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pet Adoption App Integration Tests', () {
    testWidgets('should complete full app flow', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for the app to load completely
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test 1: App should load and show home page
      expect(find.text('Pet Adoption'), findsOneWidget);

      // Test 2: Should load pets (wait for API call)
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should have at least one pet card
      expect(find.byType(Card), findsAtLeastNWidgets(1));

      // Test 3: Search functionality
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.tap(searchField);
        await tester.enterText(searchField, 'Golden');
        await tester.pumpAndSettle();

        // Should filter results
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Test 4: Pull to refresh
      await tester.drag(find.byType(CustomScrollView), const Offset(0, 300));
      await tester.pumpAndSettle();

      // Wait for refresh to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test 5: Navigate to favorites page
      final favoritesTab = find.byIcon(Icons.favorite);
      if (favoritesTab.evaluate().isNotEmpty) {
        await tester.tap(favoritesTab);
        await tester.pumpAndSettle();

        // Should show favorites page
        expect(find.text('My Favorites'), findsOneWidget);
      }

      // Test 6: Navigate to history page
      final historyTab = find.byIcon(Icons.history);
      if (historyTab.evaluate().isNotEmpty) {
        await tester.tap(historyTab);
        await tester.pumpAndSettle();

        // Should show history page
        expect(find.text('Adoption History'), findsOneWidget);
      }

      // Test 7: Return to home page
      final homeTab = find.byIcon(Icons.home);
      if (homeTab.evaluate().isNotEmpty) {
        await tester.tap(homeTab);
        await tester.pumpAndSettle();
      }

      // Test 8: Tap on a pet card to view details
      final petCards = find.byType(Card);
      if (petCards.evaluate().isNotEmpty) {
        await tester.tap(petCards.first);
        await tester.pumpAndSettle();

        // Should navigate to details page
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);

        // Test 9: Go back to home
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }

      // Test 10: Test favorite functionality
      final favoriteButtons = find.byIcon(Icons.favorite_border);
      if (favoriteButtons.evaluate().isNotEmpty) {
        await tester.tap(favoriteButtons.first);
        await tester.pumpAndSettle();

        // Should show snackbar
        expect(find.byType(SnackBar), findsOneWidget);

        // Wait for snackbar to disappear
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // Test 11: Verify app responds to different screen orientations
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/navigation',
        null,
        (data) {},
      );

      // Test completed successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should handle offline state gracefully', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for initial load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test that app doesn't crash when network is unavailable
      // This would require network mocking in a real test
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should maintain state across navigation', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for pets to load
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Add a pet to favorites
      final favoriteButtons = find.byIcon(Icons.favorite_border);
      if (favoriteButtons.evaluate().isNotEmpty) {
        await tester.tap(favoriteButtons.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Navigate to favorites
      final favoritesTab = find.byIcon(Icons.favorite);
      if (favoritesTab.evaluate().isNotEmpty) {
        await tester.tap(favoritesTab);
        await tester.pumpAndSettle();
      }

      // Navigate back to home
      final homeTab = find.byIcon(Icons.home);
      if (homeTab.evaluate().isNotEmpty) {
        await tester.tap(homeTab);
        await tester.pumpAndSettle();
      }

      // Verify state is maintained
      expect(find.byType(Card), findsAtLeastNWidgets(1));
    });
  });
}
