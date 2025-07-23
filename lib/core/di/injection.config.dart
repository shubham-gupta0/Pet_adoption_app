// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/datasources/favorites_local_datasource.dart' as _i482;
import '../../data/datasources/pet_cache_datasource.dart' as _i202;
import '../../data/datasources/pet_local_datasource.dart' as _i1009;
import '../../data/datasources/pet_remote_datasource.dart' as _i540;
import '../../data/repositories/pet_repository_impl.dart' as _i63;
import '../../domain/repositories/pet_repository.dart' as _i627;
import '../../domain/usecases/adopt_pet.dart' as _i781;
import '../../domain/usecases/get_pets.dart' as _i466;
import '../../presentation/details/cubit/details_cubit.dart' as _i964;
import '../../presentation/favorites/bloc/favorites_bloc.dart' as _i175;
import '../../presentation/favorites/bloc/list_bloc.dart' as _i917;
import '../../presentation/home/bloc/home_bloc.dart' as _i315;
import '../api/network_module.dart' as _i124;
import '../navigation/app_router.dart' as _i630;
import '../navigation/router_module.dart' as _i358;
import '../services/network_service.dart' as _i463;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final networkModule = _$NetworkModule();
  final routerModule = _$RouterModule();
  gh.singleton<_i361.Dio>(() => networkModule.dio);
  gh.lazySingleton<_i630.AppRouter>(() => routerModule.router);
  gh.factory<_i540.PetRemoteDataSource>(
      () => _i540.PetRemoteDataSourceImpl(gh<_i361.Dio>()));
  gh.factory<_i202.PetCacheDataSource>(() => _i202.PetCacheDataSourceImpl());
  gh.factory<_i463.NetworkService>(() => _i463.NetworkServiceImpl());
  gh.factory<_i482.FavoritesLocalDataSource>(
      () => _i482.FavoritesLocalDataSourceImpl());
  gh.factory<_i1009.PetLocalDataSource>(() => _i1009.PetLocalDataSourceImpl());
  gh.factory<_i627.PetRepository>(() => _i63.PetRepositoryImpl(
        gh<_i540.PetRemoteDataSource>(),
        gh<_i1009.PetLocalDataSource>(),
        gh<_i202.PetCacheDataSource>(),
        gh<_i463.NetworkService>(),
      ));
  gh.factory<_i175.FavoritesBloc>(() => _i175.FavoritesBloc(
        gh<_i482.FavoritesLocalDataSource>(),
        gh<_i627.PetRepository>(),
        gh<_i202.PetCacheDataSource>(),
      ));
  gh.factory<_i781.AdoptPetUseCase>(
      () => _i781.AdoptPetUseCase(gh<_i627.PetRepository>()));
  gh.factory<_i466.GetPetsUseCase>(
      () => _i466.GetPetsUseCase(gh<_i627.PetRepository>()));
  gh.factory<_i315.HomeBloc>(() => _i315.HomeBloc(gh<_i466.GetPetsUseCase>()));
  gh.factory<_i964.DetailsCubit>(
      () => _i964.DetailsCubit(gh<_i627.PetRepository>()));
  gh.factory<_i917.ListBloc>(() => _i917.ListBloc(gh<_i627.PetRepository>()));
  return getIt;
}

class _$NetworkModule extends _i124.NetworkModule {}

class _$RouterModule extends _i358.RouterModule {}
