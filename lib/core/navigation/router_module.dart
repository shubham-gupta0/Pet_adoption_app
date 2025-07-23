import 'package:injectable/injectable.dart';
import 'package:pet_adoption_app/core/navigation/app_router.dart';

@module
abstract class RouterModule {
  @lazySingleton
  AppRouter get router => AppRouter();
}
