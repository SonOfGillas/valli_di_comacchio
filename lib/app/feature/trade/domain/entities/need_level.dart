enum NeedLevel {
  notInterested,
  veryLow,
  low,
  avarege,
  aboveAverage,
  substatial,
  high,
  veryHigh,
  direNeed,
  extremeNeed,
}

const needStandardDeviation = 0.1;

extension NeedLevelExtension on NeedLevel {
  // this value rappresent the demand level of the resource for a specific npc
  // 1 = highest possible demand
  // 0 = the npc doesn't care about the resource
  double get value {
    switch (this) {
      case NeedLevel.notInterested:
        return 0.0;
      case NeedLevel.veryLow:
        return 0.1;
      case NeedLevel.low:
        return 0.2;
      case NeedLevel.avarege:
        return 0.3;
      case NeedLevel.aboveAverage:
        return 0.4;
      case NeedLevel.substatial:
        return 0.5;
      case NeedLevel.high:
        return 0.6;
      case NeedLevel.veryHigh:
        return 0.7;
      case NeedLevel.direNeed:
        return 0.8;
      case NeedLevel.extremeNeed:
        return 0.9;
    }
  }
}

NeedLevel needLevelFromValue(double value) {
  if (value < 0.1) {
    return NeedLevel.notInterested;
  } else if (value < 0.2) {
    return NeedLevel.veryLow;
  } else if (value < 0.3) {
    return NeedLevel.low;
  } else if (value < 0.4) {
    return NeedLevel.avarege;
  } else if (value < 0.5) {
    return NeedLevel.aboveAverage;
  } else if (value < 0.6) {
    return NeedLevel.substatial;
  } else if (value < 0.7) {
    return NeedLevel.high;
  } else if (value < 0.8) {
    return NeedLevel.veryHigh;
  } else if (value < 0.9) {
    return NeedLevel.direNeed;
  } else {
    return NeedLevel.extremeNeed;
  }
}
