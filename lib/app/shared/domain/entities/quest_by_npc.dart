import 'package:valli_di_comacchio/app/feature/quests_page/domain/nft_treasure_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quiz_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/talk_to_npc_quest.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

class QuestsByNpc {
  final Npc npc;
  List<BasicQuest> quests;

  QuestsByNpc({required this.npc, this.quests = const []});

  factory QuestsByNpc.fromJson(Map<String, dynamic> json) {
    final List<BasicQuest> questList = [];
    final npc = Npc.fromJson(json['npc'] as Map<String, dynamic>);
    final jsonQuests = json['quests'] as List<dynamic>?;
    if (jsonQuests == null || jsonQuests.isEmpty) {
      return QuestsByNpc(npc: npc, quests: questList);
    } else {
      for (var questJson in jsonQuests) {
        if (questJson is Map<String, dynamic>) {
          final quest = BasicQuest.fromJson(questJson);
          if (quest.type == QuestType.nftTreasureHunt ||
              quest.type == QuestType.nftTreasureHide) {
            final treasureHuntQuest = NftTreasureQuest.fromJson(questJson);
            questList.add(treasureHuntQuest);
          } else if (quest.type == QuestType.talkToNpc) {
            final talkToNpcQuest = TalkToNpcQuest.fromJson(questJson);
            questList.add(talkToNpcQuest);
          } else if (quest.type == QuestType.quiz) {
            final quizQuest = QuizQuest.fromJson(questJson);
            questList.add(quizQuest);
          } else {
            questList.add(quest);
          }
        } else {
          throw FormatException(
              'Invalid quest format: ${questJson.runtimeType}');
        }
      }
      return QuestsByNpc(npc: npc, quests: questList);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'npc': npc.toJson(),
      'quests': quests
          .map((quest) => {
                if (quest is NftTreasureQuest)
                  {
                    ...quest.toJson(),
                  }
                else if (quest is TalkToNpcQuest)
                  {
                    ...quest.toJson(),
                  }
                else if (quest is QuizQuest)
                  {
                    ...quest.toJson(),
                  }
                else
                  {
                    ...quest.toJson(),
                  }
              })
          .toList(),
    };
  }
}

class AllQuests {
  List<QuestsByNpc> npcsWithQuests;

  AllQuests({this.npcsWithQuests = const []});

  List<BasicQuest> get allAcceptedQuests {
    return npcsWithQuests
        .expand((npcQuest) => npcQuest.quests)
        .where((quest) => quest.accepted)
        .toList();
  }

  editNpcQuests(Npc npc, List<BasicQuest> quests) {
    final existingNpcQuests = npcsWithQuests.firstWhere(
      (npcQuest) => npcQuest.npc.id == npc.id,
      orElse: () => QuestsByNpc(npc: npc),
    );
    existingNpcQuests.quests = quests;
    npcsWithQuests.removeWhere((npcQuest) => npcQuest.npc.id == npc.id);
    npcsWithQuests.add(existingNpcQuests);
  }

  List<BasicQuest> getNpcQuests(Npc npc) {
    return npcsWithQuests
        .firstWhere(
          (npcQuest) => npcQuest.npc.id == npc.id,
          orElse: () => QuestsByNpc(npc: npc),
        )
        .quests;
  }

  acceptQuest(Npc npc, BasicQuest quest) {
    final npcQuests = getNpcQuests(npc);
    final updatedQuests = npcQuests.map((q) {
      if (q.uuid == quest.uuid) {
        return q.copyWith(accepted: true);
      }
      return q;
    }).toList();
    editNpcQuests(npc, updatedQuests);
  }

  removeQuest(Npc npc, BasicQuest quest) {
    final npcQuests = getNpcQuests(npc);
    final updatedQuests = npcQuests.where((q) => q.uuid != quest.uuid).toList();
    editNpcQuests(npc, updatedQuests);
  }

  toJson() {
    return {
      'npcsWithQuests':
          npcsWithQuests.map((npcQuest) => npcQuest.toJson()).toList(),
    };
  }

  factory AllQuests.fromJson(Map<String, dynamic> json) {
    final npcsWithQuests = (json['npcsWithQuests'] as List<dynamic>?)
            ?.map((npcQuestJson) => QuestsByNpc.fromJson(npcQuestJson))
            .toList() ??
        [];
    return AllQuests(npcsWithQuests: npcsWithQuests);
  }
}
