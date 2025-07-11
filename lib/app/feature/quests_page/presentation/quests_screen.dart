import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_state.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestsCubit, QuestsState>(
      builder: (context, state) {
        return Scaffold(
            appBar: ValliAppBar(),
            backgroundColor: AppColors.palette_secondary,
            body: state.status == QuestPageStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: state.mode == QuestPageMode.acceptedQuests
                        ? const AcceptedQuestsWidget()
                        : const NpcQuestsWidget(),
                  ),
            bottomNavigationBar: FooterNavBar());
      },
    );
  }
}

class AcceptedQuestsWidget extends StatelessWidget {
  const AcceptedQuestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestsCubit, QuestsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          // Implement the UI for accepted quests
          children: [
            Text('Accepted Quests'),
            ...state.acceptedQuests.map((quest) {
              return ListTile(
                title: Text(quest.uuid),
                subtitle: Text(quest.type.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    // Handle quest completion
                  },
                ),
              );
            })
          ],
        );
      },
    );
  }
}

class NpcQuestsWidget extends StatelessWidget {
  const NpcQuestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestsCubit, QuestsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('NPC Quests ${state.selectedNpc?.name ?? 'Unknown'}'),
            ...state.npcQuests.map((quest) {
              return ListTile(
                title: Text(quest.uuid),
                subtitle: Text(quest.type.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    // Handle quest completion
                  },
                ),
              );
            })
          ],
        );
      },
    );
  }
}
