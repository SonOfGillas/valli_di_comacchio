import 'package:bloc/bloc.dart';
import 'package:valli_di_comacchio/app/feature/auth/logic/auth_event.dart';
import 'package:valli_di_comacchio/app/feature/auth/logic/auth_state.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/core/form_fields/email_field.dart';
import 'package:valli_di_comacchio/app/shared/core/form_fields/password_field.dart';
import 'package:valli_di_comacchio/app/shared/core/form_fields/username_field.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.userRepository,
    required this.appCubit,
  }) : super(
          const AuthState(
            status: AuthStatus.idle,
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
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      if (state.mode == AuthMode.login) {
        await _login(event, emit);
      } else {
        await _register(event, emit);
      }
    } on Exception catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        failure: Failure.fromException(e),
      ));
      return;
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        failure: UnknownFailure(),
      ));
      return;
    }
  }

  Future<void> _login(
    MainButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    final loginResult = await userRepository.login(
      email: state.email.value,
      password: state.password.value,
    );

    AppUser? loginUser;

    loginResult.fold(onSuccess: (user) async {
      loginUser = user;
    }, onFailure: (failure) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        failure: failure,
      ));
    });

    if (loginUser != null) {
      await appCubit.setLocalUser(
        loginUser!,
        state.password.value,
      );
      emit(state.copyWith(status: AuthStatus.succeeded));
    }
  }

  Future<void> _register(
    MainButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    final registrationResult = await userRepository.register(
      username: state.username.value,
      password: state.password.value,
      email: state.email.value,
    );

    AppUser? registerUser;

    registrationResult.fold(onSuccess: (user) {
      registerUser = user;
    }, onFailure: (failure) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        failure: failure,
      ));
    });

    if (registerUser != null) {
      await appCubit.setLocalUser(
        registerUser!,
        state.password.value,
      );
      emit(state.copyWith(status: AuthStatus.succeeded));
    }
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
        state.mode == AuthMode.login ? AuthMode.register : AuthMode.login;
    emit(state.copyWith(mode: newMode));
  }
}
