import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class MainButtonPressed extends AuthEvent {
  const MainButtonPressed();

  @override
  List<Object> get props => [];
}

class EmailEdit extends AuthEvent {
  const EmailEdit({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

class PasswordEdit extends AuthEvent {
  const PasswordEdit({required this.password});

  final String password;

  @override
  List<Object?> get props => [password];
}

class RepeatPasswordEdit extends AuthEvent {
  const RepeatPasswordEdit({required this.repeatPassword});

  final String repeatPassword;

  @override
  List<Object?> get props => [repeatPassword];
}

class UsernameEdit extends AuthEvent {
  const UsernameEdit({required this.username});

  final String username;

  @override
  List<Object?> get props => [username];
}

class TogglePasswordIconPressed extends AuthEvent {
  @override
  List<Object?> get props => [];
}

abstract class SwitchAccessMode extends AuthEvent {
  const SwitchAccessMode();

  @override
  List<Object?> get props => [];
}

class GoToLogin extends SwitchAccessMode {
  const GoToLogin();

  @override
  List<Object?> get props => [];
}

class GoToRegister extends SwitchAccessMode {
  const GoToRegister();

  @override
  List<Object?> get props => [];
}

class GoToGuest extends SwitchAccessMode {
  const GoToGuest();

  @override
  List<Object?> get props => [];
}

class GuestModeSelected extends AuthEvent {
  const GuestModeSelected();

  @override
  List<Object?> get props => [];
}
