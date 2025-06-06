import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/shared/components/npc_dialog_box/npc_dialog_box.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

class NpcDisplayHeader extends StatelessWidget {
  const NpcDisplayHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradeBloc, TradeState>(
      buildWhen: (previous, current) => previous.npc != current.npc,
      builder: (context, state) {
        return Stack(
          children: [
            Row(
              children: [
                Image.asset(
                  AppImages.rosario,
                  height: 230,
                ),
                // Expanded(
                //   child: Container(
                //     height: 230,
                //     child: Padding(
                //       padding: const EdgeInsets.all(16.0),
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           H3('NPC Wealth'),
                //           Column(
                //             children: [
                //               SvgPicture.asset(
                //                 AppIcons.money,
                //                 width: 34,
                //                 height: 34,
                //                 colorFilter: ColorFilter.mode(
                //                   AppColors.palette_primary,
                //                   BlendMode.srcIn,
                //                 ),
                //               ),
                //               // TODO: Replace with actual wealth value
                //               LabelText('1023'),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: NpcDialogueBox(
                speaker: state.npc?.name ?? '',
                text:
                    'Sarebbe comodo se potessi vendermi le risorse segnate in rosso. Scegli una risorsa che vuoi scambiare con me. ', // l10n.tradeNpcDialogue,
                onTap: () {
                  // Handle tap
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
