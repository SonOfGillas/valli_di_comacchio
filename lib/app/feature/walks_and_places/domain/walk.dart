import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

enum WalkType {
  pedestrian,
  bicycle,
  // horse,
}

enum WalkDifficulty {
  easy,
  medium,
  hard,
}

class Walk {
  Walk({
    this.name = '',
    this.trackGeoPoints = const [],
    this.type = WalkType.pedestrian,
    this.trackDistance = 0, // in meters
    this.trackDuration = 0, // in seconds
    this.upHill = 0, // in meters
    this.downHill = 0, // in meters
    this.slope = 0, // in % from 0 to 100
    this.price = 0, // in euros
  });

  String name;
  List<GeoPoint> trackGeoPoints;
  WalkType type = WalkType.pedestrian;
  int trackDistance; // in meters
  int trackDuration; // in seconds
  double upHill; // in meters
  double downHill; // in meters
  double slope; // in % from 0 to 100
  double price; // in euros

  String get trackDistanceFormatted {
    if (trackDistance < 1000) {
      return '$trackDistance m';
    } else {
      return '${(trackDistance / 1000).toStringAsFixed(2)} km';
    }
  }

  String get trackDurationFormatted {
    final hours = (trackDuration / 3600).floor();
    final seconds = trackDuration % 60;
    final minutes = (((trackDuration % 3600) / 60) + seconds).floor();

    return '${hours > 0 ? '$hours h ' : ''}${minutes > 0 ? '$minutes min ' : ''}';
  }

  String get upHillFormatted {
    return '${upHill.toStringAsFixed(2)} m';
  }

  String get downHillFormatted {
    return '${downHill.toStringAsFixed(2)} m';
  }

  String get slopeFormatted {
    return '${slope.toStringAsFixed(2)} %';
  }

  String get priceFormatted {
    return price > 0 ? price.toStringAsFixed(2) : 'Free';
  }
}
