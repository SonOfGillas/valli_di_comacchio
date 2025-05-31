import 'package:valli_di_comacchio/app/feature/trade/domain/entities/production_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/gaussian_rnd_number_generation.dart';

int generateRandomStorageAmount(
    TradeResource tradeResource, ProductionLevel productionLevel) {
  final min = 0.0;
  final max = tradeResource.maxProduction;
  final mean = productionLevel.value * max;
  final standardDeviation = productionStandardDeviation * max;
  final randomNumber =
      generateGaussianRandomNumberInRange(mean, standardDeviation, min, max);
  return randomNumber.toInt();
}
