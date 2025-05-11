import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';

enum OfferType {
  buy,
  sell,
}

class Prices {
  Prices({
    required this.sellingPriceMin,
    required this.sellingStartingPrice,
    required this.buingStartingPrice,
    required this.buingPriceMax,
  });

  final int sellingPriceMin;
  final int sellingStartingPrice;
  final int buingStartingPrice;
  final int buingPriceMax;
}

class TradeResourceOffer extends Equatable {
  TradeResourceOffer({
    required this.tradeResourceInventory,
    this.offerQuantity = 1,
    required this.offerType,
  }) {
    prices = getPrices(offerQuantity);
  }

  final TradeResourceInventory tradeResourceInventory;
  late final Prices prices;
  final int offerQuantity;
  final OfferType offerType;

  @override
  List<Object?> get props => [
        tradeResourceInventory,
        prices,
        offerQuantity,
        offerType,
      ];

  TradeResourceOffer copyWith({
    int? offerQuantity,
    TradeResourceInventory? tradeResourceInventory,
    OfferType? offerType,
  }) {
    return TradeResourceOffer(
      tradeResourceInventory:
          tradeResourceInventory ?? this.tradeResourceInventory,
      offerQuantity: offerQuantity ?? this.offerQuantity,
      offerType: offerType ?? this.offerType,
    );
  }

  Prices getPrices(int offerQuantity) {
    return Prices(
      sellingPriceMin: tradeResourceInventory.tradeResource.basePrice,
      sellingStartingPrice: tradeResourceInventory.tradeResource.basePrice,
      buingStartingPrice: tradeResourceInventory.tradeResource.basePrice,
      buingPriceMax: tradeResourceInventory.tradeResource.basePrice,
    );
  }
}
