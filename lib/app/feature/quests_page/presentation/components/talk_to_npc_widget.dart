import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/talk_to_npc_quest.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';

class TalkToNpcQuestWidget extends StatelessWidget {
  final TalkToNpcQuest quest;

  const TalkToNpcQuestWidget({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelText(
            '${quest.npc.name} vole che parli con ${quest.receiverNpc.name}'),
        Text(quest.talkToNpcData.message),
        LabelText('oggetti da trovare:'),
        ...quest.questItems.map((item) => ListTile(
              title: Text(item.itemName),
              subtitle: Text(
                  'lat ${item.itemLocation.latitude}\nlon ${item.itemLocation.longitude}'),
              leading: Icon(Icons.token),
              onTap: () {
                // Handle item selection
              },
            )),
      ],
    );
  }
}
