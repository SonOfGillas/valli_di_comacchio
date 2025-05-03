import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';

abstract class TradeEvent extends Equatable {
  const TradeEvent();
}

class LoadTradeData extends TradeEvent {
  const LoadTradeData({
    required this.npcId,
  });

  final String npcId;

  @override
  List<Object?> get props => [npcId];
}

class SelectTradeResource extends TradeEvent {
  const SelectTradeResource({
    required this.resource,
  });

  final TradeResourceInventory resource;

  @override
  List<Object?> get props => [resource];
}

class BuyTradeResource extends TradeEvent {
  const BuyTradeResource();

  @override
  List<Object?> get props => [];
}

class SellTradeResource extends TradeEvent {
  const SellTradeResource();

  @override
  List<Object?> get props => [];
}

class TradeResourceAcceptOffert extends TradeEvent {
  const TradeResourceAcceptOffert();

  @override
  List<Object?> get props => [];
}

class TradeResourceSetPrice extends TradeEvent {
  const TradeResourceSetPrice({
    required this.price,
  });

  final int price;

  @override
  List<Object?> get props => [price];
}

class TradeResourceSetAmount extends TradeEvent {
  const TradeResourceSetAmount({
    required this.amount,
  });

  final int amount;

  @override
  List<Object?> get props => [amount];
}

class TradeResourceMotivation extends TradeEvent {
  const TradeResourceMotivation({
    required this.motivation,
  });

  final String motivation;

  @override
  List<Object?> get props => [motivation];
}

class TradeResourceCounterOffer extends TradeEvent {
  const TradeResourceCounterOffer();
  @override
  List<Object?> get props => [];
}
