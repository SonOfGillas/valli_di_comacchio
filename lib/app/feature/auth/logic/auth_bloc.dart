import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/auth/logic/auth_event.dart';
import 'package:valli_di_comacchio/app/feature/auth/logic/auth_state.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/core/form_fields/email_field.dart';
import 'package:valli_di_comacchio/app/shared/core/form_fields/password_field.dart';
import 'package:valli_di_comacchio/app/shared/core/form_fields/username_field.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.userRepository,
    required this.appCubit,
  }) : super(
          const AuthState(
            status: AccessStatus.idle,
          ),
        ) {
    on<MainButtonPressed>(_onButtonPressedEvent);
    on<TogglePasswordIconPressed>(_togglePasswordVisibility);
    on<EmailEdit>(_updateEmail);
    on<PasswordEdit>(_updatePassword);
    on<RepeatPasswordEdit>(_updateRepeatPassword);
    on<UsernameEdit>(_updateUsername);
    on<SwitchAccessMode>(_switchAccessMode);
  }

  final UserRepository userRepository;
  final AppCubit appCubit;

  Future<void> _onButtonPressedEvent(
    MainButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AccessStatus.loading));

    //   final result = await userRepository.login(
    //     username: state.email.value,
    //     password: state.password.value,
    //   );
    //   result.fold(
    //     onSuccess: (loginResponse) {
    //       emit(state.copyWith(status: AccessStatus.succeeded));
    //       appCubit.setLocalUser(
    //         User.fromLoginResponse(loginResponse),
    //         state.password.value,
    //       );
    //       emit(
    //         state.copyWith(
    //           passwordIsEspired: loginResponse.nextStep == AppStep.changePassword,
    //         ),
    //       );
    //       emit(state.copyWith(status: AccessStatus.idle));
    //     },
    //     onFailure: (failure) {
    //       emit(
    //         state.copyWith(
    //           status: AccessStatus.failure,
    //           failureProvider: () => failure,
    //         ),
    //       );
    //       emit(state.copyWith(status: AccessStatus.idle));
    //     },
    //   );
  }

  Future<void> _togglePasswordVisibility(
    TogglePasswordIconPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  Future<void> _updateEmail(
    EmailEdit event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        email: EmailField.dirty(value: event.email),
      ),
    );
  }

  Future<void> _updatePassword(
    PasswordEdit event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        password: PasswordField.dirty(value: event.password),
      ),
    );
  }

  Future<void> _updateRepeatPassword(
    RepeatPasswordEdit event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        repeatPassword: PasswordField.dirty(value: event.repeatPassword),
      ),
    );
  }

  Future<void> _updateUsername(
    UsernameEdit event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        username: UsernameField.dirty(value: event.username),
      ),
    );
  }

  Future<void> _switchAccessMode(
    SwitchAccessMode event,
    Emitter<AuthState> emit,
  ) async {
    final newMode =
        state.mode == AccessMode.login ? AccessMode.register : AccessMode.login;
    emit(state.copyWith(mode: newMode));
  }
}
