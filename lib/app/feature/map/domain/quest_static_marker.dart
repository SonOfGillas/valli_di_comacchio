import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';

class QuestStaticMarker {
  final String id;
  final BasicQuest relatedQuest;
  final String icon;
  final GeoPoint geoPoint;

  QuestStaticMarker({
    required this.icon,
    required this.geoPoint,
    required this.relatedQuest,
  }) : id = geoPoint.toString();
}
