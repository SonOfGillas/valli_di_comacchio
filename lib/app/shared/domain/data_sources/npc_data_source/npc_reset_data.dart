import 'dart:math';

import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/need_level.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/production_level.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/location_information.dart';
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

// always open 00:00 - 23:59
final openingAlways = [
  TimeOfDay(hour: 0, minute: 0),
  TimeOfDay(hour: 0, minute: 0),
  TimeOfDay(hour: 0, minute: 0),
  TimeOfDay(hour: 0, minute: 0),
  TimeOfDay(hour: 0, minute: 0),
  TimeOfDay(hour: 0, minute: 0),
  TimeOfDay(hour: 0, minute: 0),
];
final closingAlways = [
  TimeOfDay(hour: 23, minute: 59),
  TimeOfDay(hour: 23, minute: 59),
  TimeOfDay(hour: 23, minute: 59),
  TimeOfDay(hour: 23, minute: 59),
  TimeOfDay(hour: 23, minute: 59),
  TimeOfDay(hour: 23, minute: 59),
  TimeOfDay(hour: 23, minute: 59)
];

// open 08:00 - 20:00
final openingStandard = [
  TimeOfDay(hour: 8, minute: 0),
  TimeOfDay(hour: 8, minute: 0),
  TimeOfDay(hour: 8, minute: 0),
  TimeOfDay(hour: 8, minute: 0),
  TimeOfDay(hour: 8, minute: 0),
  TimeOfDay(hour: 8, minute: 0),
  TimeOfDay(hour: 8, minute: 0),
];
final closingStandard = [
  TimeOfDay(hour: 20, minute: 0),
  TimeOfDay(hour: 20, minute: 0),
  TimeOfDay(hour: 20, minute: 0),
  TimeOfDay(hour: 20, minute: 0),
  TimeOfDay(hour: 20, minute: 0),
  TimeOfDay(hour: 20, minute: 0),
  TimeOfDay(hour: 20, minute: 0),
];

List<Npc> generateNpcResetData() {
  return [
    Npc(
      id: 'npc_1',
      name: 'Rosario',
      imageLocalPath: AppImages.rosario,
      locationInformation: LocationInformation(
        name: 'Via dei Bilancioni',
        imagePath: AppImages.rosario_location,
        description:
            'è un percorso nel pieno della laguna di comacchio, costeggiato da una serie di bilancioni da pesca',
        subLocationsOrActivities: [
          SubLocationOrActivity(
            name: 'Passeggiata',
            opening: openingAlways,
            closing: closingAlways,
            description: 'è possibile passeggiare lungo il canale liberamente',
          ),
        ],
      ),
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
      locationInformation: LocationInformation(
        name: 'Ponte Trepponti',
        imagePath: AppImages.eelena_location,
        description:
            'Il complesso architettonico dei Trepponti, conosciuto anche come Ponte Pallotta, è il più noto ponte di Comacchio nonché il suo monumento più rappresentativo. Esso è ubicato lungo l\'antico canale navigabile Pallotta che conduceva al mare Adriatico ed era la porta fortificata della città.',
        subLocationsOrActivities: [
          SubLocationOrActivity(
            name: 'Attrazione',
            opening: openingAlways,
            closing: closingAlways,
            description:
                'è possibile visitare l\'attrazione in qualsiasi momento',
          ),
        ],
      ),
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
      locationInformation: LocationInformation(
        name: 'Lido di Spina',
        imagePath: AppImages.pino_location,
        description: 'Un lido tranquillo e rilassante.',
        subLocationsOrActivities: [
          SubLocationOrActivity(
            name: 'Bagno Faro',
            opening: openingStandard,
            closing: closingStandard,
            description: 'Stabilimento balneare',
          ),
          SubLocationOrActivity(
            name: 'Bagno hawaii',
            opening: openingStandard,
            closing: closingStandard,
            description: 'Stabilimento balneare',
          ),
          SubLocationOrActivity(
            name: 'Bagno Enjoy',
            opening: openingStandard,
            closing: closingStandard,
            description: 'Stabilimento balneare',
          ),
          SubLocationOrActivity(
            name: 'Al Sole',
            opening: openingStandard,
            closing: closingStandard,
            description: 'Stabilimento balneare',
          ),
        ],
      ),
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
      locationInformation: LocationInformation(
        name: 'Lido degli Estensi',
        imagePath: AppImages.alCarpone_location,
        description: 'Un lido vivace e pieno di vita.',
        subLocationsOrActivities: [
          SubLocationOrActivity(
            name: 'Pineta Beach',
            opening: openingStandard,
            closing: closingStandard,
            description: 'Stabilimento balneare',
          ),
          SubLocationOrActivity(
            name: 'Bagno Perla',
            opening: openingStandard,
            closing: closingStandard,
            description: 'Stabilimento balneare',
          ),
          SubLocationOrActivity(
            name: 'Bagno Oro',
            opening: openingStandard,
            closing: closingStandard,
            description: 'Stabilimento balneare',
          ),
          SubLocationOrActivity(
            name: 'Bagno Astra',
            opening: openingStandard,
            closing: closingStandard,
            description: 'Stabilimento balneare',
          ),
        ],
      ),
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
      locationInformation: LocationInformation(
        name: 'Porto Garibaldi',
        imagePath: AppImages.quaQua_location,
        description: 'Un porto vivace e pieno di attività.',
        subLocationsOrActivities: [
          SubLocationOrActivity(
            name: 'Quelli di Flip',
            opening: openingStandard,
            closing: closingStandard,
            description: 'Stabilimento balneare',
          ),
          SubLocationOrActivity(
            name: 'Bagno venere',
            opening: openingStandard,
            closing: closingStandard,
            description: 'Stabilimento balneare',
          ),
        ],
      ),
      longitude: 12.243106,
      latitude: 44.678690,
      wealth: generateRandomWealth(),
      inventory: generateRndInventory(),
      lastReset: DateTime.now(),
    ),
  ];
}
