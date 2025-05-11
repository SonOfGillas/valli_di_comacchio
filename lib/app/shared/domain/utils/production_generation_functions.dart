import 'package:valli_di_comacchio/app/shared/domain/entities/production_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/gaussian_rnd_number_generation.dart';

int generateRandomStorageAmount(
    TradeResource tradeResource, ProductionLevel productionLevel) {
  final randomNumber = generateGaussianRandomNumberInRange(
      productionLevel.value,
      productionStandardDeviation,
      0,
      tradeResource.maxProduction);
  return randomNumber.toInt();
}
