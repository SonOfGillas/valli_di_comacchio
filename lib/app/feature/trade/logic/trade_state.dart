import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_resource_offer.dart';

enum TradeStatus { idle, loading, succeeded, failure }

class TradeState {
  final TradeStatus status;
  final ServerFailure? failure;
  final Npc? npc;
  final TradeResourceInventory? selectedResource;
  final TradeResourceOffer? npcOffert;
  final TradeResourceOffer? userOffert;
  final String motivation;

  const TradeState({
    this.status = TradeStatus.idle,
    this.failure,
    this.npc,
    this.selectedResource,
    this.npcOffert,
    this.userOffert,
    this.motivation = '',
  });

  TradeState copyWith({
    TradeStatus? status,
    ServerFailure? failure,
    Npc? npc,
    TradeResourceInventory? selectedResource,
    TradeResourceOffer? npcOffert,
    TradeResourceOffer? userOffert,
    String? motivation,
  }) {
    return TradeState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      npc: npc ?? this.npc,
      selectedResource: selectedResource ?? this.selectedResource,
      npcOffert: npcOffert ?? this.npcOffert,
      userOffert: userOffert ?? this.userOffert,
      motivation: motivation ?? this.motivation,
    );
  }
}
