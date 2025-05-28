import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_resource_offer.dart';

enum TradeStatus { idle, loading, failure }

enum TradingStep { selectResource, selectOfferType, setPrice }

class TradeState {
  final TradeStatus status;
  final TradingStep step;
  final Failure? failure;
  final Npc? npc;
  final TradeResourceInventory? selectedResource;
  final TradeResourceOffer? npcOffert;
  final TradeResourceOffer? userCounterOffert;
  final String motivation;

  const TradeState({
    this.status = TradeStatus.idle,
    this.step = TradingStep.selectResource,
    this.failure,
    this.npc,
    this.selectedResource,
    this.npcOffert,
    this.userCounterOffert,
    this.motivation = '',
  });

  TradeState copyWith({
    TradeStatus? status,
    TradingStep? step,
    Failure? failure,
    Npc? npc,
    TradeResourceInventory? selectedResource,
    TradeResourceOffer? npcOffert,
    TradeResourceOffer? userCounterOffert,
    String? motivation,
  }) {
    return TradeState(
      status: status ?? this.status,
      step: step ?? this.step,
      failure: failure ?? this.failure,
      npc: npc ?? this.npc,
      selectedResource: selectedResource ?? this.selectedResource,
      npcOffert: npcOffert ?? this.npcOffert,
      userCounterOffert: userCounterOffert ?? this.userCounterOffert,
      motivation: motivation ?? this.motivation,
    );
  }
}
