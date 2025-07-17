/*
* User answer a quiz question to get a reward.
*/
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/quiz.dart';

class QuizQuest extends BasicQuest {
  final Quiz quiz;

  const QuizQuest({
    required super.uuid,
    required this.quiz,
    required super.npc,
    super.accepted = false,
    super.userShouldReceiveReward = true,
  }) : super(type: QuestType.quiz, coinReward: packetCost);

  factory QuizQuest.fromJson(Map<String, dynamic> json) {
    final BasicQuest basicQuestData = BasicQuest.fromJson(json);
    return QuizQuest(
      uuid: basicQuestData.uuid,
      quiz: Quiz.fromJson(json['quiz']),
      npc: basicQuestData.npc,
      accepted: basicQuestData.accepted,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final basicQuestData = super.toJson();
    return {
      ...basicQuestData,
      'quiz': quiz.toJson(),
    };
  }

  @override
  QuizQuest copyWith({bool? accepted, bool? userShouldReceiveReward}) {
    return QuizQuest(
      uuid: uuid,
      quiz: quiz,
      npc: npc,
      accepted: accepted ?? this.accepted,
      userShouldReceiveReward:
          userShouldReceiveReward ?? this.userShouldReceiveReward,
    );
  }
}
