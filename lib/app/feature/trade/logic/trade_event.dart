import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_resource_offer.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';

abstract class TradeEvent extends Equatable {
  const TradeEvent();
}

class LoadData extends TradeEvent {
  const LoadData({
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

class SelectOfferType extends TradeEvent {
  const SelectOfferType({
    required this.offerType,
  });

  final OfferType offerType;

  @override
  List<Object?> get props => [offerType];
}

class GoBack extends TradeEvent {
  const GoBack();

  @override
  List<Object?> get props => [];
}

class BuyTradeResource extends SelectOfferType {
  const BuyTradeResource() : super(offerType: OfferType.buy);

  @override
  List<Object?> get props => [];
}

class SellTradeResource extends SelectOfferType {
  const SellTradeResource() : super(offerType: OfferType.sell);
  final offerTyper = OfferType.sell;

  @override
  List<Object?> get props => [];
}

class AcceptOffer extends TradeEvent {
  const AcceptOffer();

  @override
  List<Object?> get props => [];
}

class SetCounterOffertPrice extends TradeEvent {
  const SetCounterOffertPrice({
    required this.price,
  });

  final int price;

  @override
  List<Object?> get props => [price];
}

class SetCounterOfferAmount extends TradeEvent {
  const SetCounterOfferAmount({
    required this.amount,
  });

  final int amount;

  @override
  List<Object?> get props => [amount];
}

class SetCounterOfferMotivation extends TradeEvent {
  const SetCounterOfferMotivation({
    required this.motivation,
  });

  final String motivation;

  @override
  List<Object?> get props => [motivation];
}

class SendCounterOffer extends TradeEvent {
  const SendCounterOffer();
  @override
  List<Object?> get props => [];
}
