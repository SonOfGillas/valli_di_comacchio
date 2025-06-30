import 'dart:math';

import 'package:valli_di_comacchio/app/feature/trade/domain/entities/need_level.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/production_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resource_inventory.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/trade_resources.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/gaussian_rnd_number_generation.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

int generateRandomWealth() {
  return Random().nextInt(17000) + 3000;
}

NeedLevel _getRndNeedLevel() {
  final random = generateGaussianRandomNumberInRange(0, 40, 0, 100);
  if (random < 10) {
    return NeedLevel.notInterested;
  } else if (random < 20) {
    return NeedLevel.veryLow;
  } else if (random < 30) {
    return NeedLevel.low;
  } else if (random < 40) {
    return NeedLevel.avarege;
  } else if (random < 50) {
    return NeedLevel.aboveAverage;
  } else if (random < 60) {
    return NeedLevel.substatial;
  } else if (random < 70) {
    return NeedLevel.high;
  } else if (random < 80) {
    return NeedLevel.veryHigh;
  } else if (random < 90) {
    return NeedLevel.direNeed;
  } else {
    return NeedLevel.extremeNeed;
  }
}

ProductionLevel _getRndProductionLevel() {
  final random = generateGaussianRandomNumberInRange(0, 40, 0, 100);
  if (random < 10) {
    return ProductionLevel.notProduced;
  } else if (random < 20) {
    return ProductionLevel.veryLow;
  } else if (random < 30) {
    return ProductionLevel.low;
  } else if (random < 40) {
    return ProductionLevel.avarege;
  } else if (random < 50) {
    return ProductionLevel.aboveAverage;
  } else if (random < 60) {
    return ProductionLevel.substatial;
  } else if (random < 70) {
    return ProductionLevel.high;
  } else if (random < 80) {
    return ProductionLevel.veryHigh;
  } else if (random < 90) {
    return ProductionLevel.overProduction;
  } else {
    return ProductionLevel.extremeOverProduction;
  }
}

generateRndInventory() {
  return tradeResourcesList
      .map(
        (tradeResource) => TradeResourceInventory(
          tradeResource: tradeResource,
          defaultProductionLevel: _getRndProductionLevel(),
          defaultNeedLevel: _getRndNeedLevel(),
        ),
      )
      .toList();
}

List<Npc> generateNpcResetData() {
  return [
    Npc(
      id: 'npc_1',
      name: 'Rosario',
      imageLocalPath: AppImages.rosario,
      locationImagePath: AppImages.rosario_location,
      locationName: 'Via dei Bilancioni',
      longitude: 12.197045,
      latitude: 44.672905,
      wealth: generateRandomWealth(),
      inventory: generateRndInventory(),
      lastReset: DateTime.now(),
    ),
    Npc(
      id: 'npc_2',
      name: 'Eelena',
      imageLocalPath: AppImages.eelena,
      locationImagePath: AppImages.eelena_location,
      locationName: 'Ponte Trepponti',
      longitude: 12.183259,
      latitude: 44.693005,
      wealth: generateRandomWealth(),
      inventory: generateRndInventory(),
      lastReset: DateTime.now(),
    ),
    Npc(
      id: 'npc_3',
      name: 'Pino',
      imageLocalPath: AppImages.pino,
      locationImagePath: AppImages.pino_location,
      locationName: 'Lido di Spina',
      longitude: 12.252110,
      latitude: 44.653382,
      wealth: generateRandomWealth(),
      inventory: generateRndInventory(),
      lastReset: DateTime.now(),
    ),
    Npc(
      id: 'npc_4',
      name: 'Al Carpone',
      imageLocalPath: AppImages.alCarpone,
      locationImagePath: AppImages.alCarpone_location,
      locationName: 'Lido degli Estensi',
      longitude: 12.247454,
      latitude: 44.669262,
      wealth: generateRandomWealth(),
      inventory: generateRndInventory(),
      lastReset: DateTime.now(),
    ),
    Npc(
      id: 'npc_5',
      name: 'Qua Qua',
      imageLocalPath: AppImages.quaQua,
      locationImagePath: AppImages.quaQua_location,
      locationName: 'Porto Garibaldi',
      longitude: 12.243106,
      latitude: 44.678690,
      wealth: generateRandomWealth(),
      inventory: generateRndInventory(),
      lastReset: DateTime.now(),
    ),
  ];
}
