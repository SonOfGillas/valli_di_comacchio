import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

class AppState extends Equatable {
  const AppState({this.user, this.npcs = const []});

  final AppUser? user;
  final List<Npc> npcs;

  AppState copyWith({
    AppUser? user,
    List<Npc>? npcs,
  }) {
    return AppState(
      user: user ?? this.user,
      npcs: npcs ?? this.npcs,
    );
  }

  @override
  List<Object?> get props => [user, npcs];
}
