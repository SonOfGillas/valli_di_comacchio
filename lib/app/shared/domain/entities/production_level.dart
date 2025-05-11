enum ProductionLevel {
  notProduced,
  veryLow,
  low,
  avarege,
  aboveAverage,
  substatial,
  high,
  veryHigh,
  overProduction,
  extremeOverProduction,
}

const productionStandardDeviation = 0.1;

extension ProductionLevelExtension on ProductionLevel {
  // this value rappresent the production level of the resource for a specific npc
  // 1 = highest possible production
  // 0 = the npc doesn't care about the resource
  double get value {
    switch (this) {
      case ProductionLevel.notProduced:
        return 0.0;
      case ProductionLevel.veryLow:
        return 0.1;
      case ProductionLevel.low:
        return 0.2;
      case ProductionLevel.avarege:
        return 0.3;
      case ProductionLevel.aboveAverage:
        return 0.4;
      case ProductionLevel.substatial:
        return 0.5;
      case ProductionLevel.high:
        return 0.6;
      case ProductionLevel.veryHigh:
        return 0.7;
      case ProductionLevel.overProduction:
        return 0.8;
      case ProductionLevel.extremeOverProduction:
        return 0.9;
    }
  }
}
