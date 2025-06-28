import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/npc_repository.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';
import 'package:valli_di_comacchio/app/shared/utils/storage.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required this.appStorage,
    required this.userRepository,
    required this.npcRepository,
  }) : super(
          const AppState(),
        );

  final AppStorage appStorage;
  final UserRepository userRepository;
  final NpcRepository npcRepository;

  Future<void> setLocalUser(
    AppUser user,
    String password,
  ) async {
    await appStorage.write(
      key: AppStorage.userKey,
      value: jsonEncode(user.toJson()),
    );
    await appStorage.write(
      key: AppStorage.userPasswordKey,
      value: password,
    );
    emit(state.copyWith(user: user));
  }

  Future<void> logout() async {
    await appStorage.delete(key: AppStorage.userKey);
    await appStorage.delete(key: AppStorage.userPasswordKey);
    await userRepository.logout();
    emit(const AppState(user: null));
  }

  Future<void> loadLocalUserData() async {
    final user = await appStorage.read(key: AppStorage.userKey);
    if (user != null) {
      final localUserData = AppUser.fromJson(jsonDecode(user));
      final userResult = await userRepository.getUserData(localUserData.id);
      userResult.fold(
        onSuccess: (user) {
          emit(state.copyWith(user: user));
        },
        onFailure: (error) {
          emit(state.copyWith(user: null));
        },
      );
    }
  }

  Future<void> updateUser(AppUser user) async {
    final result = await userRepository.updateUserData(user);
    result.fold(
      onSuccess: (_) {
        emit(state.copyWith(user: user));
      },
      onFailure: (error) {
        // TODO: Handle error if needed
      },
    );
  }

  Future<void> loadNpcs() async {
    final loadNpcsResult = await npcRepository.getAllNpcs();
    late List<Npc> npcsList;
    loadNpcsResult.fold(
      onSuccess: (npcs) {
        npcsList = npcs;
      },
      onFailure: (failure) {
        npcsList = [];
      },
    );
    emit(state.copyWith(npcs: npcsList));
  }
}
