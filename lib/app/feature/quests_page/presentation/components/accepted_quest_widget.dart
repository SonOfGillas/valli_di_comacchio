import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_cubit.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/logic/quests_state.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/basic_quest_component.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h2/h2.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/quest_by_npc.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';

class AcceptedQuestsWidget extends StatelessWidget {
  const AcceptedQuestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestsCubit, QuestsState>(
      builder: (context, state) {
        final acceptedQuests = context.read<QuestsCubit>().acceptedQuests;
        return state.status == QuestPageStatus.loading
            ? const Center(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                ],
              ))
            : acceptedQuests.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppIcons.empty_folder,
                            height: 64,
                            colorFilter: ColorFilter.mode(
                              AppColors.palette_primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(height: 16),
                          LabelText(
                            'Non hai ancora accettato nessuna missione.',
                            withBoarder: false,
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // Implement the UI for accepted quests
                      children: [
                        ...acceptedQuests.map((questByNpc) {
                          return NpcAcceptedQuest(
                            questsByNpc: questByNpc,
                          );
                        })
                      ],
                    ),
                  );
      },
    );
  }
}

class NpcAcceptedQuest extends StatefulWidget {
  final QuestsByNpc questsByNpc;

  const NpcAcceptedQuest({super.key, required this.questsByNpc});

  @override
  State<NpcAcceptedQuest> createState() => _NpcAcceptedQuestState();
}

class _NpcAcceptedQuestState extends State<NpcAcceptedQuest> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final acceptedQuests =
        widget.questsByNpc.quests.where((quest) => quest.accepted).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      color: AppColors.palette_secondary,
      child: ExpansionTile(
        backgroundColor: AppColors.palette_secondary,
        iconColor: AppColors.palette_primary,
        collapsedIconColor: AppColors.palette_primary,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            widget.questsByNpc.npc.imageLocalPath,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ),
        trailing: AnimatedRotation(
          turns: _isExpanded ? 0.5 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.palette_primary,
            size: 32,
          ),
        ),
        title: H2(
          widget.questsByNpc.npc.name,
        ),
        subtitle: LabelText(
          '${acceptedQuests.length} missioni accettate',
          withBoarder: false,
        ),
        children: acceptedQuests.map((quest) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: BasicQuestComponent(
              quest: quest,
            ),
          );
        }).toList(),
      ),
    );
  }
}
