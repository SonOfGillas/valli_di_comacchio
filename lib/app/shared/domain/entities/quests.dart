import 'package:valli_di_comacchio/app/feature/quests_page/domain/nft_treasure_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quiz_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/talk_to_npc_quest.dart';

class Quests {
  List<BasicQuest> quests;

  Quests({this.quests = const []});

  factory Quests.fromJson(Map<String, dynamic> json) {
    final List<BasicQuest> questList = [];
    final jsonQuests = json['quests'] as List<dynamic>?;
    if (jsonQuests == null || jsonQuests.isEmpty) {
      return Quests(quests: questList);
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
      return Quests(quests: questList);
    }
  }

  Map<String, dynamic> toJson() {
    return {
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
