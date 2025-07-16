import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/quest_by_npc.dart';

class AllQuests {
  List<QuestsByNpc> npcsWithQuests;

  AllQuests({List<QuestsByNpc>? npcsWithQuests})
      : npcsWithQuests = npcsWithQuests ?? <QuestsByNpc>[];

  List<QuestsByNpc> get allAcceptedQuests {
    return npcsWithQuests
        .where((npcQuest) => npcQuest.quests.any((quest) => quest.accepted))
        .map((npcQuest) => QuestsByNpc(
              npc: npcQuest.npc,
              quests: npcQuest.quests.where((quest) => quest.accepted).toList(),
            ))
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
