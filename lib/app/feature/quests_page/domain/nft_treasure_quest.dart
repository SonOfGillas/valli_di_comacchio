/*
* User answer must hide or fund an AI generate NFT to get a reward.
*/
import 'dart:io';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quest_utils.dart';

class NftTreasureQuest extends BasicQuest {
  final File nft;
  final GeoPoint? location;

  NftTreasureQuest({
    required super.uuid,
    required this.nft,
    required super.type,
    required super.npc,
    super.accepted = false,
  })  : location = type == QuestType.nftTreasureHunt
            ? generateRandomLocationNearNpc(npc)
            : null,
        super(
          coinReward:
              type == QuestType.nftTreasureHunt ? packetCost * 2 : packetCost,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'nft': nft.path,
    };
  }

  factory NftTreasureQuest.fromJson(Map<String, dynamic> json) {
    final basicQuestData = BasicQuest.fromJson(json);
    return NftTreasureQuest(
      uuid: basicQuestData.uuid,
      type: basicQuestData.type,
      nft: File(json['nft'] as String),
      npc: basicQuestData.npc,
      accepted: basicQuestData.accepted,
    );
  }

  @override
  NftTreasureQuest copyWith({
    bool? accepted,
  }) {
    return NftTreasureQuest(
      uuid: uuid,
      nft: nft,
      type: type,
      npc: npc,
      accepted: accepted ?? this.accepted,
    );
  }
}
