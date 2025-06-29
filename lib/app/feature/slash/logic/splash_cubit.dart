import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/slash/logic/splash_state.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required this.userRepository,
    required this.appCubit,
  }) : super(SplashLoading()) {
    _checkInitialConfiguration();
  }

  final UserRepository userRepository;

  final AppCubit appCubit;

  Future<void> _checkInitialConfiguration() async {
    emit(SplashLoading());

    try {
      final loginCheckResult = await userRepository.isLoggedIn();
      bool isLoggedIn = false;
      loginCheckResult.fold(onSuccess: (loggedIn) async {
        isLoggedIn = loggedIn;
      }, onFailure: (failure) {
        isLoggedIn = false;
      });
      await appCubit.loadNpcs();
      if (isLoggedIn) {
        await appCubit.loadLocalUserData();
        emit(SplashSetupCompleted(loginFailed: false));
      } else {
        emit(SplashSetupCompleted(loginFailed: true));
      }
    } catch (e) {
      emit(SplashSetupCompleted(loginFailed: true));
    }
  }
}
