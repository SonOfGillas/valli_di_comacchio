import 'package:equatable/equatable.dart';

abstract class TradeEvent extends Equatable {
  const TradeEvent();
}

class LoadTradeData extends TradeEvent {
  const LoadTradeData({
    required this.tradeId,
  });

  final String tradeId;

  @override
  List<Object?> get props => [tradeId];
}

class SelectTradeResource extends TradeEvent {
  const SelectTradeResource({
    required this.resource,
  });

  final String resource;

  @override
  List<Object?> get props => [resource];
}

class BuyTradeResource extends TradeEvent {
  const BuyTradeResource({
    required this.resource,
  });

  final String resource;

  @override
  List<Object?> get props => [resource];
}

class SellTradeResource extends TradeEvent {
  const SellTradeResource({
    required this.resource,
  });

  final String resource;

  @override
  List<Object?> get props => [resource];
}

class TradeResourceAcceptOffert extends TradeEvent {
  const TradeResourceAcceptOffert({
    required this.resource,
  });

  final String resource;

  @override
  List<Object?> get props => [resource];
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
  const TradeResourceCounterOffer({
    required this.resource,
  });

  final String resource;

  @override
  List<Object?> get props => [resource];
}
