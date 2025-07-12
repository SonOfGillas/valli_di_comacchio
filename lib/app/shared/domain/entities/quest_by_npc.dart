import 'package:valli_di_comacchio/app/feature/quests_page/domain/nft_treasure_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quiz_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/talk_to_npc_quest.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

class QuestsByNpc {
  final Npc npc;
  List<BasicQuest> quests;

  QuestsByNpc({required this.npc, List<BasicQuest>? quests})
      : quests = quests ?? <BasicQuest>[];

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
      'quests': quests.map((quest) {
        if (quest is NftTreasureQuest) {
          return quest.toJson();
        } else if (quest is TalkToNpcQuest) {
          return quest.toJson();
        } else if (quest is QuizQuest) {
          return quest.toJson();
        } else {
          return quest.toJson();
        }
      }).toList(),
    };
  }

  copyWith({
    Npc? npc,
    List<BasicQuest>? quests,
  }) {
    return QuestsByNpc(
      npc: npc ?? this.npc,
      quests: quests ?? this.quests,
    );
  }
}

class AllQuests {
  List<QuestsByNpc> npcsWithQuests;

  AllQuests({List<QuestsByNpc>? npcsWithQuests})
      : npcsWithQuests = npcsWithQuests ?? <QuestsByNpc>[];

  List<BasicQuest> get allAcceptedQuests {
    return npcsWithQuests
        .expand((npcQuest) => npcQuest.quests)
        .where((quest) => quest.accepted)
        .toList();
  }

  AllQuests editNpcQuests(Npc npc, List<BasicQuest> quests) {
    // Create a copy of the current list
    final updatedNpcsWithQuests = List<QuestsByNpc>.from(npcsWithQuests);
    // Remove existing entry for this NPC
    updatedNpcsWithQuests.removeWhere((npcQuest) => npcQuest.npc.id == npc.id);
    // Add the updated entry
    updatedNpcsWithQuests.add(QuestsByNpc(npc: npc, quests: quests));
    // Return a new AllQuests instance with the updated list
    return AllQuests(npcsWithQuests: updatedNpcsWithQuests);
  }

  List<BasicQuest> getNpcQuests(Npc npc) {
    return npcsWithQuests
        .firstWhere(
          (npcQuest) => npcQuest.npc.id == npc.id,
          orElse: () => QuestsByNpc(npc: npc),
        )
        .quests;
  }

  AllQuests acceptQuest(Npc npc, BasicQuest quest) {
    final npcQuests = getNpcQuests(npc);
    final updatedQuests = npcQuests.map((q) {
      if (q.uuid == quest.uuid) {
        return q.copyWith(accepted: true);
      }
      return q;
    }).toList();
    return editNpcQuests(npc, updatedQuests);
  }

  AllQuests removeQuest(Npc npc, BasicQuest quest) {
    final npcQuests = getNpcQuests(npc);
    final updatedQuests = npcQuests.where((q) => q.uuid != quest.uuid).toList();
    return editNpcQuests(npc, updatedQuests);
  }

  Map<String, dynamic> toJson() {
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
