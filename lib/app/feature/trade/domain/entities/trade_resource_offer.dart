import 'package:equatable/equatable.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_data.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/offer_type.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/user.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/utils/price_functions.dart';

//this generates the default quantity of the resource that the NPC wants to buy or sell
int getDefaultQuantity(
    TradeResourceInventory tradeResourceInventory, OfferType offerType) {
  if (offerType == OfferType.buy) {
    // a negative demand means that the NPC has a surplus of the resource
    return tradeResourceInventory.demand < 0
        ? -tradeResourceInventory.demand
        : 1;
  } else if (offerType == OfferType.sell) {
    // a positive demand means that the NPC needs the resource
    return tradeResourceInventory.demand > 0
        ? tradeResourceInventory.demand
        : 1;
  }
  return 1; // Default quantity if no conditions are met
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
    int? manualOfferQuantity,
    this.manualOfferPrice, // by defualt is equal to starting price
  }) : offerQuantity = manualOfferQuantity ??
            getDefaultQuantity(tradeResourceInventory, offerType) {
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
      return tradeData.startingPrice;
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
    final x = tradeResourceInventory.demandNormalized;
    return x;
  }

  /*
  * demandAfterTransactionNormalized is a number that represents the demand of the resource as a percentage
  * after the transaction is applied. this is compared to the overall need of that resource by the NPC.
  * for example: 
  * 1 means that the NPC miss the 100% of the resource he needs,
  * -1 means that the NPC has the double amount of resource he needs
  * this value can't never be more than 1 but it can be less than -1.
  * With the demandNormalized it's use to calculate the acceptable price limits for the NPC.
  */
  double get demandAfterTransactionNormalized {
    final needs = tradeResourceInventory.needs;
    final double demandAfterTransaction = offerType == OfferType.buy
        ? tradeResourceInventory
            .demandAfterBuingTransaction(offerQuantity)
            .toDouble()
        : tradeResourceInventory
            .demandAfterSellingTransaction(offerQuantity)
            .toDouble();
    if (needs == 0) {
      // considered as if need is 1 to avoid division by zero
      return demandAfterTransaction;
    }
    return demandAfterTransaction / needs;
  }

  TradeData updateTradeData(int offerQuantity) {
    final tradeResource = tradeResourceInventory.tradeResource;
    // TODO fix maxExchangebleQuantity and idealExchangebleQuantity
    if (offerType == OfferType.buy) {
      // the user is buying the resource from the NPC
      return TradeData.buy(
        resource: tradeResource,
        minPrice: getPrice(tradeResource, demandNormalized),
        //set the starting price as if the npc will never lose the resource in the transaction
        startingPrice:
            getPrice(tradeResource, demandAfterTransactionNormalized),
        maxExchangebleQuantity: tradeResourceInventory.storage,
        idealExchangebleQuantity: getDefaultQuantity(
          tradeResourceInventory,
          OfferType.buy,
        ),
      );
    } else {
      // the user is selling the resource to the NPC
      return TradeData.sell(
        resource: tradeResource,
        maxPrice: getPrice(tradeResource, demandNormalized),
        //set the starting price as if the npc has already that much resources
        startingPrice:
            getPrice(tradeResource, demandAfterTransactionNormalized),
        maxExchangebleQuantity: tradeResourceInventory.needs,
        idealExchangebleQuantity: getDefaultQuantity(
          tradeResourceInventory,
          OfferType.sell,
        ),
      );
    }
  }

  bool isOfferValid(User user, Npc npc) {
    if (offerType == OfferType.buy) {
      final userWealthCheck = user.wealth >= offerPrice * offerQuantity;
      final priceCheck =
          offerPrice <= tradeData.maxPrice && offerPrice >= tradeData.minPrice;
      final quantityCheck = tradeResourceInventory.storage >= offerQuantity;
      return userWealthCheck && priceCheck && quantityCheck;
    } else if (offerType == OfferType.sell) {
      final npcWealthCheck = npc.wealth >= offerPrice * offerQuantity;
      final priceCheck =
          offerPrice <= tradeData.maxPrice && offerPrice >= tradeData.minPrice;
      final quantityCheck = user.inventory
              .firstWhere(
                (element) =>
                    element.tradeResource.id ==
                    tradeResourceInventory.tradeResource.id,
              )
              .storage >=
          offerQuantity;
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
    int? manualOfferQuantity,
    TradeResourceInventory? tradeResourceInventory,
    OfferType? offerType,
    int? manualOfferPrice,
  }) {
    return TradeResourceOffer(
      tradeResourceInventory:
          tradeResourceInventory ?? this.tradeResourceInventory,
      manualOfferQuantity: manualOfferQuantity ?? offerQuantity,
      offerType: offerType ?? this.offerType,
      manualOfferPrice: manualOfferPrice ?? this.manualOfferPrice,
    );
  }
}
