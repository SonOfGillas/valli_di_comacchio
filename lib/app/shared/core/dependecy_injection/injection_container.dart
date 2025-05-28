import 'package:get_it/get_it.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/core/config/config.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_data_source_mock.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/resources_inventory_data_source/resources_inventory_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/resources_inventory_data_source/resources_inventory_data_source_mock.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source_mock.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/npc_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';
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

    // Data Sources
    ..registerLazySingleton<UserDataSource>(
      () => UserDataSourceMock(),
    )
    ..registerLazySingleton<ResourcesInventoryDataSource>(
      () => ResourcesInventoryDataSourceMock(),
    )
    ..registerLazySingleton<NpcDataSource>(() => NpcDataSourceMock())

    // Repositories
    ..registerLazySingleton<UserRepository>(
      () => UserRepository(
        userDataSource: sl(),
        resourcesInventoryDataSource: sl(),
      ),
    )
    ..registerLazySingleton<NpcRepository>(
      () => NpcRepository(
        npcDataSource: sl(),
        resourcesInventoryDataSource: sl(),
      ),
    )

    // AppState
    ..registerLazySingleton<AppCubit>(
        () => AppCubit(appStorage: sl(), userRepository: sl()))

    // TRADE
    ..registerFactory<TradeBloc>(
      () => TradeBloc(
        appCubit: sl(),
        userRepository: sl(),
        npcRepository: sl(),
      ),
    );
}
