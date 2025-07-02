import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/slash/logic/splash_state.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
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
      // try to login automatically with the local saved user data
      final loginCheckResult = await userRepository.autoLogin();
      AppUser? loggedUser;
      loginCheckResult.fold(onSuccess: (user) async {
        loggedUser = user;
      });
      // load the setup data for the app cubit
      await appCubit.loadSetUpData(loggedUser);
      emit(SplashSetupCompleted(loginFailed: loggedUser == null));
    } catch (e) {
      emit(SplashSetupCompleted(loginFailed: true));
    }
  }
}
