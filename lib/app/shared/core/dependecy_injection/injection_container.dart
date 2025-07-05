import 'package:get_it/get_it.dart';
import 'package:valli_di_comacchio/app/feature/auth/logic/auth_bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/map/logic/map_cubit.dart';
import 'package:valli_di_comacchio/app/feature/map/presentation/map_page.dart';
import 'package:valli_di_comacchio/app/feature/slash/logic/splash_cubit.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/trade_page.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/logic/walks_and_places_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/core/config/config.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/ai_generation_data_source/ai_generation_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/ai_generation_data_source/chatgbt_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/auth_data_source/auth_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/cloud_firestore/cloud_firestore.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/event_data_source/event_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/firebase_npc_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/npc_data_source/npc_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/app_storage_user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/firebase_user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/user_data_source/user_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/walk_data_source/walk_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/event_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/npc_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/walk_repository.dart';
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
    ..registerLazySingleton<LocalUserDataSource>(
      () => AppStorageUserDataSource(sl<AppStorage>()),
    )
    ..registerLazySingleton<RemoteUserDataSource>(
      () => FirebaseUserDataSource(cloudFirestoreDataSource: sl()),
    )
    ..registerLazySingleton<NpcDataSource>(
        () => FirebaseNpcDataSource(cloudFirestoreDataSource: sl()))
    ..registerLazySingleton<AiGenerationDataSource>(
        () => ChatGbtDataSource(config: sl()))
    ..registerLazySingleton<AuthServiceDataSource>(
      () => AuthServiceDataSource(),
    )
    ..registerLazySingleton<WalkDataSource>(
      () => WalkDataSource(sl()),
    )
    ..registerLazySingleton<EventDataSource>(
      () => EventDataSource(sl()),
    )

    // Repositories
    ..registerLazySingleton<UserRepository>(
      () => UserRepository(
        authDataSource: sl(),
        localUserDataSource: sl(),
        remoteUserDataSource: sl(),
      ),
    )
    ..registerLazySingleton<NpcRepository>(
      () => NpcRepository(npcDataSource: sl(), aiGenerationDataSource: sl()),
    )
    ..registerLazySingleton<WalkRepository>(
      () => WalkRepository(sl()),
    )
    ..registerLazySingleton<EventRepository>(
      () => EventRepository(sl()),
    )

    // AppState
    ..registerLazySingleton<AppCubit>(() => AppCubit(
        userRepository: sl(),
        npcRepository: sl(),
        walkRepository: sl(),
        eventRepository: sl()))

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

    // Map
    ..registerFactoryParam<MapCubit, MapParameters, void>(
        (param, _) => MapCubit(param))

    // Trade
    ..registerFactoryParam<TradeBloc, TradePageParameters, void>(
      (param, _) => TradeBloc(
        appCubit: sl(),
        userRepository: sl(),
        npcRepository: sl(),
        tradePageParameters: param,
      ),
    )

    // Cards
    ..registerFactory<CardCubit>(
      () => CardCubit(
        appCubit: sl(),
        userRepository: sl(),
      ),
    )

    // Walks and Places
    ..registerFactory<WalksAndPlacesCubit>(
      () => WalksAndPlacesCubit(
        appCubit: sl(),
      ),
    );
}
