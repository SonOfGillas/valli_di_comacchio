import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quiz_quest.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class QuizQuestWidget extends StatelessWidget {
  final QuizQuest quest;

  const QuizQuestWidget({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8),
        LabelText('Come funziona'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Per completare questa missione, devi rispondere correttamente alla domanda di ${quest.npc.name}. che comparità quando accetterai la missione',
            style: AppTextStyles.labelOnPaletteLight,
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
