import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quiz_quest.dart';

class QuizQuestWidget extends StatelessWidget {
  final QuizQuest quest;

  const QuizQuestWidget({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(quest.quiz.question),
        ...quest.quiz.answers.map((answer) => ListTile(
              title: Text(answer.answer),
              onTap: () {
                // Handle option selection
              },
            ))
      ],
    );
  }
}
