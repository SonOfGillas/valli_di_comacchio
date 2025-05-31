import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_data.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/user.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/utils/price_functions.dart';

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
    required this.offerType,
    this.offerQuantity = 1, // by default should be equal to demand,
    this.manualOfferPrice, // by defualt is equal to starting price
  }) {
    tradeData = updateTradeData(offerQuantity);
  }

  final TradeResourceInventory tradeResourceInventory;
  final OfferType offerType;
  /*
  * offerQuantity is the amount of resource that the user/npc wants to buy or sell.
  * it must respect the User/NPC wealth and TradeData boundaries.
  */
  final int offerQuantity;
  /*
  * manualOfferPrice is the price of the resource that the user/npc wants to buy or sell.
  * It must respect the TradeData boundaries.
  */
  final int? manualOfferPrice;

  int get offerPrice {
    if (manualOfferPrice != null) {
      return manualOfferPrice!;
    } else {
      return offerType == OfferType.buy
          ? tradeData.buingStartingPrice
          : tradeData.sellingStartingPrice;
    }
  }

  int get totalCost {
    return offerPrice * offerQuantity;
  }

  /*
  * tradeData are reference data for trade the resource.
  * those data are used with the AI integration to generate 
  * realistic exchanges between the user and the NPC.
  */
  late final TradeData tradeData;

  /*
  * demandNormalized is a number between -1 and 1 that represents the demand of the resource,
  * With the demandAfterTransactionNormalized it's use to calculate the acceptable price limits for the NPC.
  * 1 means that the resource is needed in a large amount
  * -1 means that the npc wants to get rid of the resource
  */
  double get demandNormalized {
    return tradeResourceInventory.demandNormalized;
  }

  /*
  * demandAfterTransactionNormalized is a number between -1 and 1 that represents the demand of the resource 
  * if this transactionOffer will be finalized. With the demandNormalized it's use to calculate the acceptable
  * price limits for the NPC.
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

  TradeData updateTradeData(int offerQuantity) {
    final tradeResource = tradeResourceInventory.tradeResource;
    return TradeData(
      buingStartingPrice: getPrice(tradeResource, demandNormalized),
      buingPriceMin: getPrice(tradeResource, demandAfterTransactionNormalized),
      buingOptinalQuantity: getBuingOptinalQuantity(),
      sellingPriceMax: getPrice(tradeResource, demandNormalized),
      sellingStartingPrice:
          getPrice(tradeResource, demandAfterTransactionNormalized),
      sellingOptinalQuantity: getSellingOptinalQuantity(),
    );
  }

  int getBuingOptinalQuantity() {
    return tradeResourceInventory.demand < 0
        ? -tradeResourceInventory.demand
        : 1;
  }

  int getSellingOptinalQuantity() {
    return tradeResourceInventory.demand > 0
        ? tradeResourceInventory.demand
        : 1;
  }

  bool isOfferValid(User user, Npc npc) {
    if (offerType == OfferType.buy) {
      final userWealthCheck = user.wealth >= offerPrice * offerQuantity;
      final priceCheck = offerPrice <= tradeData.buingPriceMax &&
          offerPrice >= tradeData.buingPriceMin;
      final quantityCheck = false;
      return userWealthCheck && priceCheck && quantityCheck;
    } else if (offerType == OfferType.sell) {
      final npcWealthCheck = npc.wealth >= offerPrice * offerQuantity;
      final priceCheck = offerPrice <= tradeData.sellingPriceMax &&
          offerPrice >= tradeData.sellingStartingPrice;
      final quantityCheck = false;
      return npcWealthCheck && priceCheck && quantityCheck;
    } else {
      return false;
    }
  }

  @override
  List<Object?> get props => [
        tradeResourceInventory,
        tradeData,
        offerQuantity,
        offerType,
      ];

  TradeResourceOffer copyWith({
    int? offerQuantity,
    TradeResourceInventory? tradeResourceInventory,
    OfferType? offerType,
    int? manualOfferPrice,
  }) {
    return TradeResourceOffer(
        tradeResourceInventory:
            tradeResourceInventory ?? this.tradeResourceInventory,
        offerQuantity: offerQuantity ?? this.offerQuantity,
        offerType: offerType ?? this.offerType,
        manualOfferPrice: manualOfferPrice ?? this.manualOfferPrice);
  }
}
