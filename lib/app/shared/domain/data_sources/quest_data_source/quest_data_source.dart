import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:valli_di_comacchio/app/feature/quests_page/domain/nft_treasure_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quiz_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/talk_to_npc_quest.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/ai_generation_data_source/ai_generation_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/quests.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/quest_repository.dart';
import 'package:valli_di_comacchio/app/shared/utils/storage.dart';

class QuestDataSource {
  final AiGenerationDataSource aiGenerationDataSource;
  final AppStorage appStorage;

  QuestDataSource(
      {required this.aiGenerationDataSource, required this.appStorage});

  /* get quests for a specific NPC, if there aren't enough quests generate new ones */
  Future<List<BasicQuest>> generateQuestsForNpc(
      Npc npc, List<Npc> allNpcs) async {
    final questData = await appStorage.read(key: AppStorage.questsKey);
    final List<BasicQuest> npcQuests = [];
    if (questData != null) {
      final quests = Quests.fromJson(jsonDecode(questData));
      final savedNpcQuests =
          quests.quests.where((q) => q.npc.id == npc.id).toList();
      if (savedNpcQuests.isNotEmpty) {
        npcQuests.addAll(savedNpcQuests);
      }
    }
    if (npcQuests.length < questByNpc) {
      final newQuests =
          await generateNewQuests(npc, questByNpc - npcQuests.length, allNpcs);
      npcQuests.addAll(newQuests);
    }
    // save updated quests to storage
    await appStorage.write(
      key: AppStorage.questsKey,
      value: jsonEncode(Quests(quests: npcQuests).toJson()),
    );
    return Future.value(npcQuests);
  }

  Future<List<BasicQuest>> generateNewQuests(
      Npc npc, int count, List<Npc> allNpcs) async {
    final List<BasicQuest> newQuests = [];
    for (int i = 0; i < count; i++) {
      // get quest types
      final questTypes = QuestType.values;
      // randomly select a quest type
      final randomType = questTypes[Random().nextInt(questTypes.length)];
      // generate quest based on type
      switch (randomType) {
        case QuestType.talkToNpc:
          final possibleNpcReceivers =
              allNpcs.where((n) => n.id != npc.id).toList();
          final randomReceiver = possibleNpcReceivers[
              Random().nextInt(possibleNpcReceivers.length)];
          final talkToNpcData = await aiGenerationDataSource
              .generateTalkToNpcQuestData(randomReceiver);
          final quest = TalkToNpcQuest(
            receiverNpc: randomReceiver,
            talkToNpcData: talkToNpcData,
            npc: npc,
          );
          newQuests.add(quest);
          break;
        case QuestType.quiz:
          final quiz = await aiGenerationDataSource.generateQuiz();
          final quest = QuizQuest(
            npc: npc,
            question: quiz,
          );
          newQuests.add(quest);
          break;
        case QuestType.nftTreasureHide:
          final nft = await aiGenerationDataSource.generateNft();
          final quest = NftTreasureQuest(
            type: QuestType.nftTreasureHide,
            nft: nft,
            npc: npc,
          );
          newQuests.add(quest);
          break;
        case QuestType.nftTreasureHunt:
          final nftHunt = await aiGenerationDataSource.generateNft();
          final quest = NftTreasureQuest(
            type: QuestType.nftTreasureHunt,
            nft: nftHunt,
            npc: npc,
          );
          newQuests.add(quest);
          break;
      }
    }
    return Future.value(newQuests);
  }

  Future<List<BasicQuest>> acceptedQuests(Npc npc) async {
    return Future.value([]);
  }

  Future<void> acceptQuest(BasicQuest quest) async {
    return Future.value(null);
  }

  Future<void> completeQuest(BasicQuest quest) async {
    return Future.value(null);
  }

  Future<List<File>> collectedNfts() async {
    return Future.value([]);
  }
}
