import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/map/presentation/map_page.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/talk_to_npc_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/quest_element_button.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class TalkToNpcQuestWidget extends StatelessWidget {
  final TalkToNpcQuest quest;

  const TalkToNpcQuestWidget({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              quest.npc.imageLocalPath,
              height: 100,
            ),
            Icon(Icons.arrow_forward, size: 50),
            Image.asset(
              quest.receiverNpc.imageLocalPath,
              height: 100,
            ),
          ],
        ),
        LabelText(
            '${quest.npc.name} vole che parli con ${quest.receiverNpc.name}'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            quest.talkToNpcData.message,
            style: AppTextStyles.labelOnPaletteLight,
          ),
        ),
        SizedBox(height: 8),
        // Quest items table
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.palette_primary, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
            },
            children: [
              // Header row
              TableRow(
                decoration: BoxDecoration(
                  color: AppColors.palette_primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: LabelText(
                      'Oggetti da trovare',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: LabelText(
                      'Status',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              // Data rows
              ...quest.questItems.map((item) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 100,
                          child: QuestElementButton(
                            icon: Icon(
                              Icons.location_on,
                              color: AppColors.palette_primary,
                            ),
                            label: item.itemName,
                            onPressed: () {
                              context.go(
                                RoutesPaths.map,
                                extra: MapParameters(
                                  positionToShow: item.itemLocation,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16.0),
                        child: item.isFound
                            ? Icon(
                                Icons.check_circle,
                                color: AppColors.shade_green_100,
                                size: 24,
                              )
                            : Icon(
                                Icons.circle,
                                color: AppColors.shade_red_100,
                                size: 24,
                              ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        SizedBox(height: 8),
        LabelText('Come funziona'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
              'Per completare questa missione, devi raccogliere gli oggetti elencati muovendoti sulla mappa, infine raggiungi la  posizione di ${quest.receiverNpc.name} e parlara con lui.',
              style: AppTextStyles.labelOnPaletteLight),
        ),
      ],
    );
  }
}
