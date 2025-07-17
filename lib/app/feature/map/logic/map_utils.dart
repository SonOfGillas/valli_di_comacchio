import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/feature/map/domain/quest_static_marker.dart';
import 'package:valli_di_comacchio/app/feature/map/logic/map_state.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/utils/haversine_distance.dart';

const userDistanceToPickItem = 20; // meters

bool userCanPickItem(
    AppState appState, MapState mapState, GeoPoint itemPosition) {
  // In dev mode, the user can always pick items
  if (appState.devMode) return true;
  // Check if the user is close enough to the item
  final lastRecordedPosition = mapState.lastRecordedUserPosition;
  if (lastRecordedPosition == null) return false;
  // Calculate the distance between the item position and the last recorded user position
  final distance = haversineDistance(
    itemPosition.latitude,
    itemPosition.longitude,
    lastRecordedPosition.latitude,
    lastRecordedPosition.longitude,
  );
  return distance <= userDistanceToPickItem;
}

BasicQuest getQuestRelatedToQuestItem(
    AppState appState, QuestStaticMarker selectedQuestItem) {
  final acceptedQuests = appState.allQuests.allAcceptedQuests
      .expand((questByNpc) => questByNpc.quests)
      .toList();
  return acceptedQuests.firstWhere(
    (quest) => quest.uuid == selectedQuestItem.relatedQuestId,
    orElse: () => throw Exception(
        'Quest not found for selected quest item: ${selectedQuestItem.relatedQuestId}'),
  );
}
