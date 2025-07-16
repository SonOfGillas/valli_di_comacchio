import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_state.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class NpcList extends StatelessWidget {
  const NpcList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestsCubit, QuestsState>(
      builder: (context, state) {
        final npcList = context.read<QuestsCubit>().npcs;
        return GridView.builder(
          itemCount: npcList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final npc = npcList[index];
            return InkWell(
              onTap: () {
                context.read<QuestsCubit>().loadQuests(
                      QuestPageParameters(selectedNpc: npc),
                    );
              },
              child: Card(
                color: AppColors.palette_primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        npc.imageLocalPath,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    H3(npc.name),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
