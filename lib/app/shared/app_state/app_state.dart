import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';

class AppState extends Equatable {
  const AppState({
    this.user,
    this.fcmToken = '',
  });

  final AppUser? user;
  final String fcmToken;

  AppState copyWith({
    AppUser? user,
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
