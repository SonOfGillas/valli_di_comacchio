import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/feature/home/domain/walk.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/walk_data_source/walk_data_source.dart';
import 'package:xml/xml.dart';

Future<Walk> getWalkFromWalkInfo(WalkInfoLocation walkInfo) async {
  final fileLocation = 'assets/walks';
  final gpxFileContent =
      await rootBundle.loadString('$fileLocation/${walkInfo.gpxFileName}');
  final document = XmlDocument.parse(gpxFileContent);

  final name = document.findAllElements('name');
  final trackPoints = document.findAllElements('trkpt');
  final segments = document.findAllElements('segment');
  final profile = document.findAllElements('osmand:profile').first.firstChild;

  if (name.isEmpty) throw Exception('No name found');
  if (trackPoints.isEmpty) throw Exception('No track points found');
  if (segments.isEmpty) throw Exception('No segments found');
  if (profile == null) throw Exception('No profile found');

  // Extract GeoPoints from track points
  final List<GeoPoint> points = [];
  double? currentElevation;
  int upHill = 0;
  int downHill = 0;
  for (var point in trackPoints) {
    final lat = double.parse(point.getAttribute('lat')!);
    final lon = double.parse(point.getAttribute('lon')!);
    points.add(GeoPoint(latitude: lat, longitude: lon));

    final elevationElement = point.getElement('ele')!;
    final elevation = double.parse(elevationElement.firstChild!.value!);
    if (currentElevation != null) {
      if (elevation > currentElevation) {
        upHill += (elevation - currentElevation).toInt();
      } else if (elevation < currentElevation) {
        downHill += (currentElevation - elevation).toInt();
      }
    } else {
      currentElevation = elevation;
    }
  }

  final int trackDistance = _calculateTrackDistance(points).round();
  final double slope = upHill > 0 || downHill > 0
      ? (upHill - downHill) / trackDistance * 100
      : 0;

  // Sum track duraction of each segment
  final double trackDuration = segments
      .map((segment) => double.parse(segment.getAttribute('segmentTime')!))
      .fold(0.0, (a, b) => a + b);

  final type = profile.value?.toLowerCase() == 'pedestrian'
      ? WalkType.pedestrian
      : WalkType.bicycle;

  return Walk(
    name: name.first.firstChild!.value!,
    imageFilePath: '$fileLocation/${walkInfo.imageFileName}',
    trackGeoPoints: points,
    type: type,
    trackDistance: trackDistance,
    trackDuration: trackDuration.round(),
    upHill: upHill,
    downHill: downHill,
    slope: slope,
    price: walkInfo.price,
  );
}

double _calculateTrackDistance(List<GeoPoint> trackPoints) {
  if (trackPoints.length < 2) return 0.0;

  double totalDistance = 0.0;

  for (int i = 1; i < trackPoints.length; i++) {
    final prevPoint = trackPoints.elementAt(i - 1);
    final currentPoint = trackPoints.elementAt(i);

    final lat1 = prevPoint.latitude.toDouble();
    final lon1 = prevPoint.longitude.toDouble();
    final lat2 = currentPoint.latitude.toDouble();
    final lon2 = currentPoint.longitude.toDouble();

    totalDistance += _haversineDistance(lat1, lon1, lat2, lon2);
  }

  return totalDistance;
}

// Haversine formula to calculate distance between two GPS points
double _haversineDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371000; // Earth's radius in meters

  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);

  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_toRadians(lat1)) *
          math.cos(_toRadians(lat2)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);

  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  return earthRadius * c;
}

double _toRadians(double degrees) {
  return degrees * (math.pi / 180);
}
