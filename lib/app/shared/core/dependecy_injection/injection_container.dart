import 'package:get_it/get_it.dart';
import 'package:valli_di_comacchio/app/feature/auth/logic/auth_bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/slash/logic/splash_cubit.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/trade_page.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/core/config/config.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/ai_generation_data_source/ai_generation_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/ai_generation_data_source/chatgbt_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/auth_data_source/auth_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/cloud_firestore/cloud_firestore.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/firebase_npc_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/resources_inventory_data_source/resources_inventory_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/resources_inventory_data_source/resources_inventory_data_source_mock.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/firebase_user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
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
    ..registerLazySingleton<CloudFirestoreDataSource>(
      () => CloudFirestoreDataSource(),
    )
    ..registerLazySingleton<UserDataSource>(
      () => FirebaseUserDataSource(cloudFirestoreDataSource: sl()),
    )
    ..registerLazySingleton<ResourcesInventoryDataSource>(
      () => ResourcesInventoryDataSourceMock(),
    )
    ..registerLazySingleton<NpcDataSource>(
        () => FirebaseNpcDataSource(cloudFirestoreDataSource: sl()))
    ..registerLazySingleton<AiGenerationDataSource>(
        () => ChatGbtDataSource(config: sl()))
    ..registerLazySingleton<AuthDataSource>(
      () => AuthDataSource(),
    )

    // Repositories
    ..registerLazySingleton<UserRepository>(
      () => UserRepository(
        userDataSource: sl(),
        resourcesInventoryDataSource: sl(),
        authDataSource: sl(),
      ),
    )
    ..registerLazySingleton<NpcRepository>(
      () => NpcRepository(
          npcDataSource: sl(),
          resourcesInventoryDataSource: sl(),
          aiGenerationDataSource: sl()),
    )

    // AppState
    ..registerLazySingleton<AppCubit>(() =>
        AppCubit(appStorage: sl(), userRepository: sl(), npcRepository: sl()))

    // Slash
    ..registerFactory<SplashCubit>(
      () => SplashCubit(appCubit: sl(), userRepository: sl()),
    )

    // Auth
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        userRepository: sl(),
        appCubit: sl(),
      ),
    )

    // TRADE
    ..registerFactoryParam<TradeBloc, TradePageParameters, void>(
      (param, _) => TradeBloc(
        appCubit: sl(),
        userRepository: sl(),
        npcRepository: sl(),
        tradePageParameters: param,
      ),
    )

    // CARDS
    ..registerFactory<CardCubit>(
      () => CardCubit(
        appStorage: sl(),
        userRepository: sl(),
      ),
    );
}
