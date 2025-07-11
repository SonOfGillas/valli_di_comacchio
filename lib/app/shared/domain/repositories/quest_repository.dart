import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/shared/core/error/failures/failures.dart';
import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/quest_data_source/quest_data_source.dart';
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

  AsyncResult<List<BasicQuest>> getNpcQuest(Npc npc, List<Npc> allNpcs) async {
    try {
      final quests = await questDataSource.generateQuestsForNpc(npc, allNpcs);
      return Success(quests);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (exception) {
      return Error(UnknownFailure());
    }
  }

  AsyncResult<List<BasicQuest>> acceptedQuests(Npc npc) async {
    try {
      final quests = await questDataSource.acceptedQuests();
      return Success(quests);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (exception) {
      return Error(UnknownFailure());
    }
  }

  AsyncResult<List<BasicQuest>> acceptQuest(BasicQuest quest) async {
    try {
      final quests = await questDataSource.acceptQuest(quest);
      return Success(quests);
    } on Exception catch (e) {
      return Error(Failure.fromException(e));
    } catch (exception) {
      return Error(UnknownFailure());
    }
  }

  AsyncResult<CompleteQuestResponse> completeQuest(
      BasicQuest quest, AppUser user) async {
    try {
      final updatedUser = user.copyWith(
        wealth: (user.wealth + quest.coinReward),
      );
      final updatedQuestList = await questDataSource.completeQuest(quest);
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
}

class CompleteQuestResponse {
  final List<BasicQuest> updatedQuests;
  final User updatedUser;

  CompleteQuestResponse({
    required this.updatedQuests,
    required this.updatedUser,
  });
}
