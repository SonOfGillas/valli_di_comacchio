import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class QuestStaticMarker {
  final String id;
  final String icon;
  final GeoPoint geoPoint;

  QuestStaticMarker({
    required this.icon,
    required this.geoPoint,
  }) : id = geoPoint.toString();
}
