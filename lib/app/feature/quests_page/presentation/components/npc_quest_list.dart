import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_state.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/basic_quest_component.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/npc_dislay_header.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class NpcQuestList extends StatelessWidget {
  const NpcQuestList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuestsCubit, QuestsState>(
      listener: (context, state) {
        if (state.selectedNpc == null) {
          context.read<QuestsCubit>().changeTab(1);
        }
      },
      builder: (context, state) {
        final npcQuests = context.read<QuestsCubit>().npcQuests;
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  if (state.selectedNpc != null)
                    NpcDisplayHeader(
                      npc: state.selectedNpc!,
                      npcMessage:
                          'Completa una missione per guardagnare monete!',
                      showBalance: false,
                    ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 36,
                        color: AppColors.palette_primary,
                      ),
                      onPressed: () {
                        context.read<QuestsCubit>().goToNpcList();
                      },
                    ),
                  ),
                ],
              ),
              ...npcQuests.map((quest) {
                return BasicQuestComponent(
                  quest: quest,
                );
              })
            ],
          ),
        );
      },
    );
  }
}
