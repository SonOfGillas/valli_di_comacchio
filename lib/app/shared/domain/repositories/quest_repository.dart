import 'dart:io';

import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/shared/core/result/result.dart';
import 'package:valli_di_comacchio/app/shared/domain/data_sources/quest_data_source/quest_data_source.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';

const questByNpc = 3;

class QuestRepository {
  final QuestDataSource questDataSource;

  QuestRepository({
    required this.questDataSource,
  });

  AsyncResult<List<BasicQuest>> getNpcQuest(Npc npc) async {
    // check existing quests for npc

    // generate new quests if not enough (<questByNpc)
    return Success([]);
  }

  AsyncResult<List<BasicQuest>> acceptedQuests(Npc npc) async {
    return Success([]);
  }

  AsyncResult<void> acceptQuest(BasicQuest quest) async {
    return Success(null);
  }

  AsyncResult<void> completeQuest(BasicQuest quest) async {
    return Success(null);
  }

  AsyncResult<List<File>> collectedNfts() async {
    return Success([]);
  }
}
