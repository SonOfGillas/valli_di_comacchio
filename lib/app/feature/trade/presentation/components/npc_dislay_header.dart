import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/components/npc_dialog_box/npc_dialog_box.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/number_formatter.dart';
import 'package:valli_di_comacchio/app/shared/l10n/l10n.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';

class NpcDisplayHeader extends StatelessWidget {
  const NpcDisplayHeader({
    required this.npc,
    required this.npcMessage,
    this.expanded = false,
    this.showBalance = true,
    super.key,
  });

  final Npc npc;
  final String npcMessage;
  final bool expanded;
  final bool showBalance;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Stack(
      children: [
        Row(
          children: [
            Image.asset(
              npc.imageLocalPath,
              height: expanded ? 280 : 230,
            ),
            if (!expanded && showBalance)
              Expanded(
                child: SizedBox(
                  height: 230,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LabelText(l10n.tradeNpcWealth(npc.name)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LabelText(
                              formatNumber(npc.wealth),
                              withBoarder: false,
                            ),
                            SizedBox(width: 8),
                            SvgPicture.asset(
                              AppIcons.money,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                AppColors.palette_primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (npcMessage.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NpcDialogueBox(
              speaker: npc.name,
              text: npcMessage,
            ),
          ),
      ],
    );
  }
}
