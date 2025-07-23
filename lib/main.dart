import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pet_adoption_app/core/config/app_theme.dart';
import 'package:pet_adoption_app/core/di/injection.dart';
import 'package:pet_adoption_app/core/navigation/app_router.dart';
import 'package:pet_adoption_app/domain/entities/pet.dart';
import 'package:pet_adoption_app/presentation/favorites/bloc/favorites_bloc.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  // Initialize Hive for local storage
  await Hive.initFlutter();
  Hive.registerAdapter(PetAdapter()); // We will create this adapter soon
  await Hive.openBox<Pet>('adopted_pets');
  await Hive.openBox<String>('favorite_pets');
  await Hive.openBox<Pet>(
      'favorite_pets_data'); // New box for favorite pet data
  await Hive.openBox<Pet>('cached_pets'); // For caching system
  await Hive.openBox('cache_metadata'); // For cache metadata
  await Hive.openBox('settings');

  // Clear cached pets to ensure fresh data with new pricing
  final cachedPetsBox = Hive.box<Pet>('cached_pets');
  await cachedPetsBox.clear();
  final cacheMetadataBox = Hive.box('cache_metadata');
  await cacheMetadataBox.clear();

  runApp(const PetAdoptionApp());
}

class PetAdoptionApp extends StatelessWidget {
  const PetAdoptionApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MaterialApp.router for GoRouter integration
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoritesBloc>(
          create: (context) => getIt<FavoritesBloc>()..add(LoadFavorites()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Pet Adoption App',
        debugShowCheckedModeBanner: false,

        // Define light and dark themes
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,

        // Use the system theme mode initially
        // We can add a BLoC later to manage theme changes
        themeMode: ThemeMode.system,

        // Set up the router configuration
        routerConfig: getIt<AppRouter>().router,
      ),
    );
  }
}
