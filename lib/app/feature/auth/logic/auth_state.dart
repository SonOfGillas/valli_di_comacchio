import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/core/form_fields/password_field.dart';
import 'package:valli_di_comacchio/app/shared/core/form_fields/email_field.dart';
import 'package:valli_di_comacchio/app/shared/core/form_fields/username_field.dart';

enum AuthStatus { idle, loading, succeeded, failure }

enum AuthMode { login, register, guest }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.mode = AuthMode.guest,
    this.showPassword = false,
    this.failure,
    this.email = const EmailField.pure(),
    this.username = const UsernameField.pure(),
    this.password = const PasswordField.pure(),
    this.repeatPassword = const PasswordField.pure(),
  });

  final AuthStatus status;
  final AuthMode mode;
  final bool showPassword;
  final Failure? failure;
  final EmailField email;
  final UsernameField username;
  final PasswordField password;
  final PasswordField repeatPassword;

  AuthState copyWith({
    AuthStatus? status,
    AuthMode? mode,
    bool? showPassword,
    Failure? failure,
    EmailField? email,
    UsernameField? username,
    PasswordField? password,
    PasswordField? repeatPassword,
  }) {
    return AuthState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      showPassword: showPassword ?? this.showPassword,
      failure: failure ?? this.failure,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
    );
  }

  @override
  List<Object?> get props => [
        status,
        mode,
        showPassword,
        failure,
        email,
        username,
        password,
        repeatPassword,
      ];
}
