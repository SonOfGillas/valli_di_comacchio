import 'package:valli_di_comacchio/app/feature/trade/domain/entities/need_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/gaussian_rnd_number_generation.dart';

int generateRandomNeedsAmount(
    TradeResource tradeResource, NeedLevel needLevel) {
  final min = 0.0;
  final max = tradeResource.maxNeed;
  final mean = needLevel.value * max;
  final standardDeviation = needStandardDeviation * max;
  final randomNumber =
      generateGaussianRandomNumberInRange(mean, standardDeviation, min, max);
  return randomNumber.toInt();
}
