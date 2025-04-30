import 'package:get_it/get_it.dart';
import 'package:valli_di_comacchio/app/shared/core/app_state/app_bloc.dart';
import 'package:valli_di_comacchio/app/shared/core/config/config.dart';
import 'package:valli_di_comacchio/app/shared/utils/storage.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  sl
    // SHARED
    ..registerLazySingleton<AppStorage>(
      AppStorage.new,
    )
    ..registerLazySingleton<Config>(
      Config.new,
    )
    ..registerLazySingleton<AppCubit>(() => AppCubit(appStorage: sl()));
}
