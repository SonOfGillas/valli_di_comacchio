import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/event.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/walk.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

class AppState extends Equatable {
  const AppState(
      {this.user,
      this.npcs = const [],
      this.walks = const [],
      this.events = const []});

  final AppUser? user;
  final List<Npc> npcs;
  final List<Walk> walks;
  final List<Event> events;

  AppState copyWith({
    AppUser? user,
    List<Npc>? npcs,
    List<Walk>? walks,
    List<Event>? events,
  }) {
    return AppState(
      user: user ?? this.user,
      npcs: npcs ?? this.npcs,
      walks: walks ?? this.walks,
      events: events ?? this.events,
    );
  }

  @override
  List<Object?> get props => [user, npcs, walks, events];
}
