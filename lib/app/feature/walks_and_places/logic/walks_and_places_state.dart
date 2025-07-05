import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/event.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/walk.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

enum WalksAndPlacesType {
  places('Luoghi'),
  events('Eventi'),
  walks('Escursioni');

  const WalksAndPlacesType(this.displayName);
  final String displayName;
}

class WalksAndPlacesState extends Equatable {
  final String? filter;
  final List<Npc> filteredNpcs;
  final List<Event> filteredEvents;
  final List<Walk> filteredWalks;

  const WalksAndPlacesState(
      {this.filteredNpcs = const [],
      this.filteredEvents = const [],
      this.filteredWalks = const [],
      this.filter});

  @override
  List<Object?> get props =>
      [filteredNpcs, filteredEvents, filteredWalks, filter];

  WalksAndPlacesState copyWith({
    String? filter,
    List<Walk>? filteredWalks,
    List<Npc>? filteredNpcs,
    List<Event>? filteredEvents,
  }) {
    return WalksAndPlacesState(
      filter: filter ?? this.filter,
      filteredWalks: filteredWalks ?? this.filteredWalks,
      filteredNpcs: filteredNpcs ?? this.filteredNpcs,
      filteredEvents: filteredEvents ?? this.filteredEvents,
    );
  }
}
