import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_state.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/npc_list.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/npc_quest_list.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';

class NpcQuestsWidget extends StatelessWidget {
  const NpcQuestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) => previous.allQuests != current.allQuests,
      builder: (context, appState) {
        return BlocBuilder<QuestsCubit, QuestsState>(
          builder: (context, state) {
            return state.status != QuestPageStatus.loading
                ? (state.mode == QuestPageMode.npcQuests)
                    ? NpcQuestList()
                    : NpcList()
                : const Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      LabelText(
                          'Stiamo generando delle nuove missioni per te!'),
                    ],
                  ));
          },
        );
      },
    );
  }
}
