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
import 'package:valli_di_comacchio/app/shared/domain/entities/quest_by_npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/quest_repository.dart';
import 'package:valli_di_comacchio/app/shared/utils/storage.dart';

class QuestDataSource {
  final AiGenerationDataSource aiGenerationDataSource;
  final AppStorage appStorage;

  QuestDataSource(
      {required this.aiGenerationDataSource, required this.appStorage});

  Future<void> saveQuestsLocally(AllQuests allQuests) async {
    await appStorage.write(
      key: AppStorage.questsKey,
      value: jsonEncode(allQuests.toJson()),
    );
  }

  Future<AllQuests> getLocalSavedQuests() async {
    final questData = await appStorage.read(key: AppStorage.questsKey);
    if (questData != null) {
      final quests = AllQuests.fromJson(jsonDecode(questData));
      return Future.value(quests);
    }
    return Future.value(AllQuests());
  }

  /* get quests for a specific NPC, if there aren't enough quests generate new ones */
  Future<AllQuests> generateQuestsForNpc(Npc npc, List<Npc> allNpcs) async {
    final allQuests = await getLocalSavedQuests();
    List<BasicQuest> npcQuests = [];
    final savedNpcQuests = allQuests.getNpcQuests(npc);
    if (savedNpcQuests.isNotEmpty) {
      npcQuests.addAll(savedNpcQuests);
    }
    if (npcQuests.length < questByNpc) {
      final questToGenerate = questByNpc - npcQuests.length;
      final newQuests = await _generateNewQuests(npc, questToGenerate, allNpcs);
      npcQuests.addAll(newQuests);
    }
    // save updated quests to storage
    final allQuestUpdated = allQuests.editNpcQuests(npc, npcQuests);
    await saveQuestsLocally(allQuestUpdated);
    return Future.value(allQuestUpdated);
  }

  Future<List<BasicQuest>> _generateNewQuests(
      Npc npc, int count, List<Npc> allNpcs) async {
    // Create a list of futures for parallel execution
    List<Future<BasicQuest>> questFutures = [];

    for (int i = 0; i < count; i++) {
      // // get quest types
      // final questTypes =  QuestType.values;
      // // randomly select a quest type
      // final randomType = [Random().nextInt(questTypes.length)];

      // TODO: remove this code
      // get a random quest type between
      final limitedQuestSet = QuestType.values.where((type) =>
          type != QuestType.nftTreasureHunt &&
          type != QuestType.nftTreasureHide);
      final randomType =
          limitedQuestSet.elementAt(Random().nextInt(limitedQuestSet.length));

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
                    quiz: quiz,
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
    var newQuests = await Future.wait(questFutures);
    return newQuests;
  }

  Future<AllQuests> acceptQuest(Npc npc, BasicQuest quest) async {
    final localSavedQuests = await getLocalSavedQuests();
    localSavedQuests.acceptQuest(npc, quest);
    await saveQuestsLocally(localSavedQuests);
    return Future.value(localSavedQuests);
  }

  /// Completes a quest by removing it from the local storage.
  /// If the quest is of type NFT treasure hunt, the nft will be saved in the user's collection.
  /// Returns the updated list of quests after completion.
  /// NOTE this method does not update the user's wealth, this is done in the quest_repository.
  Future<AllQuests> completeQuest(Npc npc, BasicQuest quest) async {
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
    localSavedQuests.removeQuest(npc, quest);
    await saveQuestsLocally(localSavedQuests);
    return Future.value(localSavedQuests);
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
