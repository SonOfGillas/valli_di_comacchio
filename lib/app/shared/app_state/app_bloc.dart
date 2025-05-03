import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/user.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';
import 'package:valli_di_comacchio/app/shared/utils/storage.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required this.appStorage,
    required this.userRepository,
  }) : super(
          const AppState(),
        );

  final AppStorage appStorage;
  final UserRepository userRepository;

  Future<void> loadFcmToken() async {
    final fcmToken = await appStorage.read(key: AppStorage.fcmToken);
    if (fcmToken != null) {
      emit(state.copyWith(fcmToken: fcmToken));
    }
  }

  Future<void> setUser(
    User user,
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

  Future<void> removeUser() async {
    await appStorage.delete(key: AppStorage.userKey);
    // ignore: avoid_redundant_argument_values
    emit(const AppState(user: null));
  }

  Future<void> loadUser() async {
    final user = await appStorage.read(key: AppStorage.userKey);
    if (user != null) {
      final localUserData = User.fromJson(jsonDecode(user));
      final userResult = await userRepository.getUserData(localUserData.email);
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
}
