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
    this.imageFilePath = '',
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
  String imageFilePath; // path to the image file
  List<GeoPoint> trackGeoPoints;
  WalkType type = WalkType.pedestrian;
  int trackDistance; // in meters
  int trackDuration; // in seconds
  int upHill; // in meters
  int downHill; // in meters
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
    return '${upHill.round()} m';
  }

  String get downHillFormatted {
    return '${downHill.round()} m';
  }

  String get slopeFormatted {
    return '${slope.toStringAsFixed(2)} %';
  }

  String get priceFormatted {
    return price > 0 ? price.toStringAsFixed(2) : 'Free';
  }

  WalkDifficulty get difficulty {
    if (type == WalkType.bicycle) {
      return _getBicycleDifficulty();
    } else {
      return _getPedestrianDifficulty();
    }
  }

  WalkDifficulty _getBicycleDifficulty() {
    if (trackDistance < 4000 && upHill < 100 && downHill < 100) {
      return WalkDifficulty.easy;
    } else if (trackDistance < 10000 && upHill < 300 && downHill < 300) {
      return WalkDifficulty.medium;
    } else {
      return WalkDifficulty.hard;
    }
  }

  WalkDifficulty _getPedestrianDifficulty() {
    if (trackDistance < 2000 && upHill < 50 && downHill < 50) {
      return WalkDifficulty.easy;
    } else if (trackDistance < 4000 && upHill < 100 && downHill < 100) {
      return WalkDifficulty.medium;
    } else {
      return WalkDifficulty.hard;
    }
  }
}
