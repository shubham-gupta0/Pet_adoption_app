import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';
import 'package:pet_adoption_app/presentation/details/view/details_page.dart';
import 'package:pet_adoption_app/presentation/favorites/view/favorites_page.dart';
import 'package:pet_adoption_app/presentation/history/view/history_page.dart';
import 'package:pet_adoption_app/presentation/home/view/home_page.dart';
import 'package:pet_adoption_app/presentation/common_widgets/scaffold_with_nav_bar.dart';

// Private navigators for each tab
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorFavoritesKey = GlobalKey<NavigatorState>(debugLabel: 'shellFavorites');
final _shellNavigatorHistoryKey = GlobalKey<NavigatorState>(debugLabel: 'shellHistory');

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    routes: [
      // Main application shell with bottom navigation bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch for the Home tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomePage(),
                ),
              ),
            ],
          ),
          // Branch for the Favorites tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorFavoritesKey,
            routes: [
              GoRoute(
                path: '/favorites',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: FavoritesPage(),
                ),
              ),
            ],
          ),
          // Branch for the History tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHistoryKey,
            routes: [
              GoRoute(
                path: '/history',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HistoryPage(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Standalone route for the Pet Details page
      GoRoute(
        path: '/details',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final pet = state.extra as Pet;
          return DetailsPage(pet: pet);
        },
      ),
    ],
  );
}