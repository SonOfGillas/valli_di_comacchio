import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/nft_treasure_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/talk_to_npc_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/basic_quest_component.dart';

class MapQuestItems {
  final BasicQuest quest;
  final List<GeoPoint> geoPoints;
  final String icon;

  static List<GeoPoint> getGeoPoint(BasicQuest quest) {
    switch (quest.type) {
      case QuestType.talkToNpc:
        final talkToNpcQuest = quest as TalkToNpcQuest;
        return talkToNpcQuest.questItems
            .map((item) => item.itemLocation)
            .toList();
      case QuestType.nftTreasureHunt:
        final treasureHuntQuest = quest as NftTreasureQuest;
        return [
          GeoPoint(
              latitude: treasureHuntQuest.location!.latitude,
              longitude: treasureHuntQuest.location!.longitude)
        ];
      default:
        // For other quest types, return an empty list
        return [];
    }
  }

  MapQuestItems({
    required this.quest,
  })  : geoPoints = getGeoPoint(quest),
        icon = questIcon(quest.type);
}
