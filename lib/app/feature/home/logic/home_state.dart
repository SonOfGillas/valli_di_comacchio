import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/home/domain/event.dart';
import 'package:valli_di_comacchio/app/feature/home/domain/walk.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

enum HomeType {
  places('Luoghi'),
  events('Eventi'),
  walks('Escursioni');

  const HomeType(this.displayName);
  final String displayName;
}

class HomeState extends Equatable {
  final String? filter;
  final List<Npc> filteredNpcs;
  final List<Event> filteredEvents;
  final List<Walk> filteredWalks;

  const HomeState(
      {this.filteredNpcs = const [],
      this.filteredEvents = const [],
      this.filteredWalks = const [],
      this.filter});

  @override
  List<Object?> get props =>
      [filteredNpcs, filteredEvents, filteredWalks, filter];

  HomeState copyWith({
    String? filter,
    List<Walk>? filteredWalks,
    List<Npc>? filteredNpcs,
    List<Event>? filteredEvents,
  }) {
    return HomeState(
      filter: filter ?? this.filter,
      filteredWalks: filteredWalks ?? this.filteredWalks,
      filteredNpcs: filteredNpcs ?? this.filteredNpcs,
      filteredEvents: filteredEvents ?? this.filteredEvents,
    );
  }
}
