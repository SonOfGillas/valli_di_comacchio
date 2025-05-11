import 'package:valli_di_comacchio/app/shared/domain/entities/need_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/gaussian_rnd_number_generation.dart';

int generateRandomNeedsAmount(
    TradeResource tradeResource, NeedLevel needLevel) {
  final randomNumber = generateGaussianRandomNumberInRange(
      needLevel.value, needStandardDeviation, 0, tradeResource.maxNeed);
  return randomNumber.toInt();
}
