import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/map/presentation/components/pick_quest_item_modal.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/nft_treasure_quest.dart';
import 'package:valli_di_comacchio/app/shared/components/appButton/glowing_button.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h2/h2.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class TreasureHideDialog extends StatelessWidget {
  final List<NftTreasureQuest> acceptedNftTreasureQuests;

  const TreasureHideDialog(
      {super.key, required this.acceptedNftTreasureQuests});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary_light,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  H2(
                    'Scegli un tesoro da nascondere',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Seleziona uno dei tesori che devi nascondere per nasconderlo nella tua attuale posizione.',
                    style: AppTextStyles.labelOnPaletteLight,
                  ),
                  SizedBox(height: 16),
                  ...acceptedNftTreasureQuests.map((quest) {
                    return Column(
                      children: [
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
                        SizedBox(height: 8),
                        GlowingButton(
                            text: 'Nascondi Qui',
                            onPressed: () {
                              onQuestCompleated(context, quest);
                            }),
                        SizedBox(height: 24),
                      ],
                    );
                  }),
                ],
              ),
            ),
            // Close button positioned at top right
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  shape: CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
