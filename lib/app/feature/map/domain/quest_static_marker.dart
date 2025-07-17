import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class QuestStaticMarker {
  final String id;
  final String relatedQuestId;
  final String relatedNpcId;
  final String icon;
  final GeoPoint geoPoint;

  QuestStaticMarker({
    required this.icon,
    required this.geoPoint,
    required this.relatedQuestId,
    required this.relatedNpcId,
  }) : id = geoPoint.toString();
}
