import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:valli_di_comacchio/app/feature/quests_page/domain/nft_treasure_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quiz_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/talk_to_npc_quest.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/ai_generation_data_source/ai_generation_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/nft_collection.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/quests.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/quest_repository.dart';
import 'package:valli_di_comacchio/app/shared/utils/storage.dart';

class QuestDataSource {
  final AiGenerationDataSource aiGenerationDataSource;
  final AppStorage appStorage;

  QuestDataSource(
      {required this.aiGenerationDataSource, required this.appStorage});

  Future<List<BasicQuest>> getLocalSavedQuests() async {
    final questData = await appStorage.read(key: AppStorage.questsKey);
    if (questData != null) {
      final quests = Quests.fromJson(jsonDecode(questData));
      return Future.value(quests.quests);
    }
    return Future.value([]);
  }

  Future<void> saveQuestsLocally(List<BasicQuest> quests) async {
    await appStorage.write(
      key: AppStorage.questsKey,
      value: jsonEncode(Quests(quests: quests).toJson()),
    );
  }

  /* get quests for a specific NPC, if there aren't enough quests generate new ones */
  Future<List<BasicQuest>> generateQuestsForNpc(
      Npc npc, List<Npc> allNpcs) async {
    final localSavedQuests = await getLocalSavedQuests();
    final List<BasicQuest> npcQuests = [];
    final savedNpcQuests =
        localSavedQuests.where((q) => q.npc.id == npc.id).toList();
    if (savedNpcQuests.isNotEmpty) {
      npcQuests.addAll(savedNpcQuests);
    }
    if (npcQuests.length < questByNpc) {
      final newQuests =
          await generateNewQuests(npc, questByNpc - npcQuests.length, allNpcs);
      npcQuests.addAll(newQuests);
    }
    // save updated quests to storage
    await saveQuestsLocally(npcQuests);
    return Future.value(npcQuests);
  }

  Future<List<BasicQuest>> generateNewQuests(
      Npc npc, int count, List<Npc> allNpcs) async {
    // Create a list of futures for parallel execution
    final List<Future<BasicQuest>> questFutures = [];

    for (int i = 0; i < count; i++) {
      // get quest types
      final questTypes = QuestType.values;
      // randomly select a quest type
      final randomType = questTypes[Random().nextInt(questTypes.length)];

      // Create future for each quest type
      switch (randomType) {
        case QuestType.talkToNpc:
          final possibleNpcReceivers =
              allNpcs.where((n) => n.id != npc.id).toList();
          final randomReceiver = possibleNpcReceivers[
              Random().nextInt(possibleNpcReceivers.length)];

          questFutures.add(aiGenerationDataSource
              .generateTalkToNpcQuestData(randomReceiver)
              .then((talkToNpcData) => TalkToNpcQuest(
                    receiverNpc: randomReceiver,
                    talkToNpcData: talkToNpcData,
                    npc: npc,
                  )));
          break;

        case QuestType.quiz:
          questFutures.add(
              aiGenerationDataSource.generateQuiz().then((quiz) => QuizQuest(
                    npc: npc,
                    question: quiz,
                  )));
          break;

        case QuestType.nftTreasureHide:
          questFutures.add(aiGenerationDataSource
              .generateNft()
              .then((nft) => NftTreasureQuest(
                    type: QuestType.nftTreasureHide,
                    nft: nft,
                    npc: npc,
                  )));
          break;

        case QuestType.nftTreasureHunt:
          questFutures.add(aiGenerationDataSource
              .generateNft()
              .then((nft) => NftTreasureQuest(
                    type: QuestType.nftTreasureHunt,
                    nft: nft,
                    npc: npc,
                  )));
          break;
      }
    }

    // Wait for all quest generation to complete in parallel
    final newQuests = await Future.wait(questFutures);
    return newQuests;
  }

  Future<List<BasicQuest>> acceptedQuests() async {
    final localSavedQuests = await getLocalSavedQuests();
    final acceptedQuests = localSavedQuests.where((q) => q.accepted).toList();
    return Future.value(acceptedQuests);
  }

  Future<List<BasicQuest>> acceptQuest(BasicQuest quest) async {
    final localSavedQuests = await getLocalSavedQuests();
    final updatedQuests = localSavedQuests.map((q) {
      if (q.uuid == quest.uuid) {
        return q.copyWith(accepted: true);
      }
      return q;
    }).toList();
    await saveQuestsLocally(updatedQuests);
    return Future.value(updatedQuests);
  }

  /// Completes a quest by removing it from the local storage.
  /// If the quest is of type NFT treasure hunt, the nft will be saved in the user's collection.
  /// Returns the updated list of quests after completion.
  Future<List<BasicQuest>> completeQuest(BasicQuest quest) async {
    if (quest.type == QuestType.nftTreasureHunt) {
      // save the NFT to the user's collection
      final nftQuest = quest as NftTreasureQuest;
      // read the current NFT collection from storage
      final collection = await collectedNfts();
      final collectionFilePaths = collection.map((file) => file.path).toList();
      // add the NFT to the collection
      collectionFilePaths.add(nftQuest.nft.path);
      // save the updated collection back to storage
      await appStorage.write(
          key: AppStorage.nftCollectionKey,
          value: jsonEncode(collectionFilePaths));
    }
    final localSavedQuests = await getLocalSavedQuests();
    final updatedQuests =
        localSavedQuests.where((q) => q.uuid != quest.uuid).toList();
    await saveQuestsLocally(updatedQuests);
    return Future.value(updatedQuests);
  }

  Future<List<File>> collectedNfts() async {
    final response = await appStorage.read(key: AppStorage.nftCollectionKey);
    if (response == null) {
      return Future.value([]);
    }
    final nftCollection = NftCollection.fromJson(jsonDecode(response));

    return Future.value(nftCollection.nftFiles);
  }
}
