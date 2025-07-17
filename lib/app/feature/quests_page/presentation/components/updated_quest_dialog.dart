import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/basic_quest_component.dart';

class UpdatedQuestDialog extends StatelessWidget {
  final BasicQuest quest;

  const UpdatedQuestDialog({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: BasicQuestComponent(quest: quest),
            ),
          ),
        ),
      ),
    );
  }
}
