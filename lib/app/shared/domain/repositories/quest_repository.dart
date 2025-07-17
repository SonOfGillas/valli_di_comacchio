import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/quest_data_source/quest_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/all_quest.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/app_user.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/repositories/user_repository.dart';

const questByNpc = 3;

class QuestRepository {
  final QuestDataSource questDataSource;
  final UserRepository userRepository;

  QuestRepository({
    required this.questDataSource,
    required this.userRepository,
  });

  AsyncResult<AllQuests> getNpcQuest(Npc npc, List<Npc> allNpcs) async {
    try {
      final quests = await questDataSource.generateQuestsForNpc(npc, allNpcs);
      return Success(quests);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (exception) {
      return Error(UnknownFailure());
    }
  }

  AsyncResult<AllQuests> localSavedQuests() async {
    try {
      final localSavedQuests = await questDataSource.getLocalSavedQuests();
      return Success(localSavedQuests);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (exception) {
      return Error(UnknownFailure());
    }
  }

  AsyncResult<AllQuests> acceptQuest(Npc npc, BasicQuest quest) async {
    try {
      final quests = await questDataSource.acceptQuest(npc, quest);
      return Success(quests);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (exception) {
      return Error(UnknownFailure());
    }
  }

  AsyncResult<CompleteQuestResponse> completeQuest(
      Npc npc, BasicQuest quest, AppUser user) async {
    try {
      final updatedUser = user.copyWith(
        wealth: (user.wealth + quest.coinReward),
      );
      final updatedQuestList = await questDataSource.completeQuest(npc, quest);
      await userRepository.updateUserData(user: updatedUser);
      return Success(CompleteQuestResponse(
        updatedQuests: updatedQuestList,
        updatedUser: updatedUser,
      ));
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (exception) {
      return Error(UnknownFailure());
    }
  }

  AsyncResult<List<File>> collectedNfts() async {
    try {
      final nfts = await questDataSource.collectedNfts();
      return Success(nfts);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (exception) {
      return Error(UnknownFailure());
    }
  }

  Future<void> resetQuestsAndNftsCollection() async {
    try {
      await questDataSource.resetQuestsAndNftsCollection();
    } on Exception catch (e) {
      throw Failure.fromException(e);
    } catch (exception) {
      throw UnknownFailure();
    }
  }
}

class CompleteQuestResponse {
  final AllQuests updatedQuests;
  final User updatedUser;

  CompleteQuestResponse({
    required this.updatedQuests,
    required this.updatedUser,
  });
}
