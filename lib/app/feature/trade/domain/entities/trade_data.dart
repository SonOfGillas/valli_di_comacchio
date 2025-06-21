// BUY -> the user is buying the resource from the NPC
// SELL -> the user is selling the resource to the NPC

import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';

class TradeData {
  const TradeData._({
    required this.maxPrice,
    required this.minPrice,
    required this.startingPrice,
    required this.maxExchangebleQuantity,
    required this.idealExchangebleQuantity,
  });

  factory TradeData.buy({
    required TradeResource resource,
    required int minPrice,
    required int startingPrice,
    required int maxExchangebleQuantity,
    required int idealExchangebleQuantity,
  }) {
    return TradeData._(
      maxPrice: resource.basePrice * 3,
      minPrice: minPrice,
      startingPrice: startingPrice,
      maxExchangebleQuantity: maxExchangebleQuantity,
      idealExchangebleQuantity: idealExchangebleQuantity,
    );
  }

  factory TradeData.sell({
    required TradeResource resource,
    required int maxPrice,
    required int startingPrice,
    required int maxExchangebleQuantity,
    required int idealExchangebleQuantity,
  }) {
    return TradeData._(
      maxPrice: maxPrice,
      minPrice: resource.basePrice ~/ 3,
      startingPrice: startingPrice,
      maxExchangebleQuantity: maxExchangebleQuantity,
      idealExchangebleQuantity: idealExchangebleQuantity,
    );
  }

  /*
  * the maximum price of the resource that the NPC is willing to pay 
  * for the resource that the user is buing/selling
  */
  final int maxPrice;
  /*
  * the minimum price that the NPC is willing to accept 
  * for the resource that the user wants to buy/sell
  */
  final int minPrice;
  /*
  * the price that the NPC offer for buing the resource 
  * at the beginning of the trading process
  */
  final int startingPrice;

  /*
  * the maximum quantity of the resource that can be exchanged
  */
  final int maxExchangebleQuantity;

  /*
  * the minimum quantity of the resource that can be exchanged
  */
  final int minExchangebleQuantity = 1;

  /*
  * the ideal quantity of the resource that the NPC wants to exchange
  */
  final int idealExchangebleQuantity;
}
