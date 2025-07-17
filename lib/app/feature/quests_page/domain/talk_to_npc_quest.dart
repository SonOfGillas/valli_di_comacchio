import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quest_utils.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/talk_to_npc_data.dart';

class TalkToNpcQuest extends BasicQuest {
  final Npc receiverNpc;
  final TalkToNpcData talkToNpcData;
  final List<QuestItem> questItems;

  TalkToNpcQuest({
    required super.uuid,
    required this.receiverNpc,
    required this.talkToNpcData,
    required super.npc,
    super.accepted = false,
    super.coinReward = packetCost * 2,
    List<QuestItem>? items,
  })  : questItems = items ??
            talkToNpcData.itemList
                .map((item) => QuestItem(
                      itemName: item.itemName,
                      itemLocation: generateRandomLocationNearNpc(npc),
                    ))
                .toList(),
        super(type: QuestType.talkToNpc);

  factory TalkToNpcQuest.fromJson(Map<String, dynamic> json) {
    final basicQuestData = BasicQuest.fromJson(json);
    return TalkToNpcQuest(
      uuid: basicQuestData.uuid,
      receiverNpc: Npc.fromJson(json['receiverNpc'] as Map<String, dynamic>),
      talkToNpcData:
          TalkToNpcData.fromJson(json['talkToNpcData'] as Map<String, dynamic>),
      npc: basicQuestData.npc,
      accepted: basicQuestData.accepted,
    );
  }

  TalkToNpcQuest setItemAsFounded(GeoPoint itemLocation) {
    final List<QuestItem> updatedQuestItems = questItems
        .map((item) {
          if (item.itemLocation == itemLocation) {
            return item.copyWith(isFound: true);
          }
          return item;
        })
        .toList()
        .cast<QuestItem>();

    return copyWith(items: updatedQuestItems);
  }

  @override
  Map<String, dynamic> toJson() {
    final basicQuestData = super.toJson();
    return {
      ...basicQuestData,
      'receiverNpc': receiverNpc.toJson(),
      'talkToNpcData': talkToNpcData.toJson(),
      'questItems': questItems.map((item) => item.toJson()).toList(),
    };
  }

  @override
  TalkToNpcQuest copyWith({
    bool? accepted,
    List<QuestItem>? items,
  }) {
    return TalkToNpcQuest(
      uuid: uuid,
      receiverNpc: receiverNpc,
      talkToNpcData: talkToNpcData,
      npc: npc,
      accepted: accepted ?? this.accepted,
      coinReward: coinReward,
      items: items ?? questItems,
    );
  }
}
