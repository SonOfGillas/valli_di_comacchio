import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:valli_di_comacchio/app/feature/map/presentation/map_page.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/nft_treasure_quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/presentation/components/quest_element_button.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/core/routes/routes_paths.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class NftTreasureQuestWidget extends StatelessWidget {
  final NftTreasureQuest quest;

  const NftTreasureQuestWidget({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (quest.type == QuestType.nftTreasureHide)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.file(quest.nft),
            ),
          ),
        if (quest.type == QuestType.nftTreasureHunt)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                LabelText(
                  'Come Funziona:',
                ),
                Text(
                  'Un immagine nft è stata nascosta sulla mappa. Devi trovarla raggiungendo questa posizione:',
                  style: AppTextStyles.labelOnPaletteLight,
                ),
                SizedBox(height: 8),
                QuestElementButton(
                  icon: Icon(
                    Icons.location_on,
                    color: AppColors.palette_primary,
                  ),
                  label: 'Posizione del tesoro',
                  onPressed: () {
                    context.go(
                      RoutesPaths.map,
                      extra: MapParameters(
                        positionToShow: quest.location,
                      ),
                    );
                  },
                ),
                SizedBox(height: 8),
                Text(
                  'E cliccando su quest\' icona:',
                  style: AppTextStyles.labelOnPaletteLight,
                ),
                Center(
                  child: SvgPicture.asset(
                    AppIcons.treasure_hunt,
                    height: 60,
                    colorFilter: ColorFilter.mode(
                      AppColors.palette_tertiary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        if (quest.type == QuestType.nftTreasureHide)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                LabelText(
                  'Come Funziona:',
                ),
                Text(
                  'Una volta accettata la missione, potrai muoverti liberamente sulla mappa e scegliere un luogo dove nascondere l\'immagine.',
                  style: AppTextStyles.labelOnPaletteLight,
                ),
                Text(
                  'Per nascondere l\'immagine, premi il pulsante con l\'icona:',
                  style: AppTextStyles.labelOnPaletteLight,
                ),
                Center(
                  child: SvgPicture.asset(
                    AppIcons.treasure_hide,
                    height: 60,
                    colorFilter: ColorFilter.mode(
                      AppColors.palette_tertiary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
      ],
    );
  }
}
