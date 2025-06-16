import 'dart:math';

import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';

/*
* This function calculates the price change based on the demand.
* the price_change is a precentage of increase or decrease of the price
* that will be applied to the base price of the resource. 
*/
int getPriceChageFunction(double demandNormalized) {
  late final double demandPercentage;
  if (demandNormalized > 1) {
    demandPercentage = 100.0;
  } else if (demandNormalized < -1) {
    demandPercentage = -100.0;
  } else {
    demandPercentage = 100 * demandNormalized;
  }

  final term1 = 1 / (0.1 + exp(-1 * (demandPercentage + 30)));
  final term2 = 1 / (0.1 + exp(-1 * (demandPercentage - 20)));
  final term3 = exp(0.06 * (demandPercentage - 20));
  final term4 = 0.3 * demandPercentage - 10;

  return (term1 + term2 + term3 + term4).toInt();
}

int getPrice(TradeResource tradeResource, double demandNormalized) {
  final priceChange = getPriceChageFunction(demandNormalized);
  print(
      'Price change: ${priceChange / 100}% for ${demandNormalized} demand normalized');
  final basePrice = tradeResource.basePrice;
  final price = basePrice + (basePrice * priceChange / 100);
  return price.toInt();
}
