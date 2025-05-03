import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';

enum OfferType {
  buy,
  sell,
}

class TradeResourceOffer extends Equatable {
  const TradeResourceOffer({
    required this.tradeResourceInventory,
    required this.price,
    required this.offerQuantity,
    required this.offerType,
  });

  final TradeResourceInventory tradeResourceInventory;
  final int price;
  final int offerQuantity;
  final OfferType offerType;

  int get totalPrice => price * offerQuantity;

  @override
  List<Object?> get props =>
      [price, offerQuantity, tradeResourceInventory, offerType];

  TradeResourceOffer copyWith({
    int? price,
    int? offerQuantity,
    TradeResourceInventory? tradeResourceInventory,
    OfferType? offerType,
  }) {
    return TradeResourceOffer(
      tradeResourceInventory:
          tradeResourceInventory ?? this.tradeResourceInventory,
      price: price ?? this.price,
      offerQuantity: offerQuantity ?? this.offerQuantity,
      offerType: offerType ?? this.offerType,
    );
  }
}
