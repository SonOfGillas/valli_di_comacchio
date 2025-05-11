import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/prices.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/price_functions.dart';

enum OfferType {
  buy, // the user is buying the resource from the NPC
  sell, // the user is selling the resource to the NPC
}

/*
* this class represents the trade resource during a transaction.
* It can be used also to showcase the general information of the trade resource.
* the TradeResourceOffer is always in realation with an specific NPC.
* it extends the information of the trade resource inventory
* with the price of the offer and the quantity.
*/
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

  /*
  * demandNormalized is a number between -1 and 1 that represents the demand of the resource 
  * 1 means that the resource is needed in a large amount
  * -1 means that the npc wants to get rid of the resource
  */
  double get demandNormalized {
    final tradeResource = tradeResourceInventory.tradeResource;
    final double min = -tradeResource.maxProduction;
    final double max = tradeResource.maxNeed;
    final double value = tradeResourceInventory.demand.toDouble();

    // Normalize demand between -1 and 1
    return (value - min) / (max - min) * 2 - 1;
  }

  /*
  * demandAfterTransactionNormalized is a number between -1 and 1 that represents the demand of the resource 
  * if this transactionOffer will be finalized. With the demandNormalized it's use to calculate the acceptable
  * price of the resources for the NPC.
  * 1 means that the resource is needed in a large amount
  * -1 means that the npc wants to get rid of the resource
  */
  double get demandAfterTransactionNormalized {
    final tradeResource = tradeResourceInventory.tradeResource;
    final double min = -tradeResource.maxProduction;
    final double max = tradeResource.maxNeed;
    final double demandAfterTransaction = offerType == OfferType.buy
        ? tradeResourceInventory
            .demandAfterBuingTransaction(offerQuantity)
            .toDouble()
        : tradeResourceInventory
            .demandAfterSellingTransaction(offerQuantity)
            .toDouble();

    // Normalize demand between -1 and 1
    return (demandAfterTransaction - min) / (max - min) * 2 - 1;
  }

  Prices getPrices(int offerQuantity) {
    final tradeResource = tradeResourceInventory.tradeResource;
    return Prices(
      buingStartingPrice: getPrice(tradeResource, demandNormalized),
      buingPriceMin: getPrice(tradeResource, demandAfterTransactionNormalized),
      sellingPriceMax: getPrice(tradeResource, demandNormalized),
      sellingStartingPrice:
          getPrice(tradeResource, demandAfterTransactionNormalized),
    );
  }

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
}
