/*
* User answer a quiz question to get a reward.
*/
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/quiz.dart';

class QuizQuest extends BasicQuest {
  final Quiz question;

  QuizQuest({
    required this.question,
    required super.npc,
    super.accepted = false,
  }) : super(type: QuestType.quiz, coinReward: packetCost);

  factory QuizQuest.fromJson(Map<String, dynamic> json) {
    final BasicQuest basicQuestData = BasicQuest.fromJson(json);
    return QuizQuest(
      question: Quiz.fromJson(json['question']),
      npc: basicQuestData.npc,
      accepted: basicQuestData.accepted,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final basicQuestData = super.toJson();
    return {
      ...basicQuestData,
      'question': question.toJson(),
    };
  }
}
