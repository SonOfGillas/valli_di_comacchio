import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/walk.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

enum WalksAndPlaces {
  walks,
  places,
}

class WalksAndPlacesState extends Equatable {
  final String? filter;
  final List<Npc> filteredNpcs;
  final List<Walk> filteredWalks;

  const WalksAndPlacesState(
      {this.filteredNpcs = const [],
      this.filteredWalks = const [],
      this.filter});

  @override
  List<Object?> get props => [filteredNpcs, filteredWalks, filter];

  WalksAndPlacesState copyWith({
    String? filter,
    List<Walk>? filteredWalks,
    List<Npc>? filteredNpcs,
  }) {
    return WalksAndPlacesState(
      filter: filter ?? this.filter,
      filteredWalks: filteredWalks ?? this.filteredWalks,
      filteredNpcs: filteredNpcs ?? this.filteredNpcs,
    );
  }
}
