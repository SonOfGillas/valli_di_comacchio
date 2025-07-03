import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/walks_and_places/domain/walk.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

class WalksAndPlacesState extends Equatable {
  final List<Walk> walks;
  final List<Npc> npcs;

  const WalksAndPlacesState({this.walks = const [], this.npcs = const []});

  @override
  List<Object?> get props => [walks, npcs];

  WalksAndPlacesState copyWith({
    List<Walk>? walks,
    List<Npc>? npcs,
  }) {
    return WalksAndPlacesState(
      walks: walks ?? this.walks,
      npcs: npcs ?? this.npcs,
    );
  }
}
