import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/user.dart';

class AppState extends Equatable {
  const AppState({
    this.user,
    this.fcmToken = '',
  });

  final User? user;
  final String fcmToken;

  AppState copyWith({
    User? user,
    String? fcmToken,
  }) {
    return AppState(
      user: user ?? this.user,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  List<Object?> get props => [user, fcmToken];
}
