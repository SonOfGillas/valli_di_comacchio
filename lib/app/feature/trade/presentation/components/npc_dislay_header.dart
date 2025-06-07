import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/components/npc_dialog_box/npc_dialog_box.dart';
import 'package:valli_di_comacchio/app/shared/l10n/l10n.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

class NpcDisplayHeader extends StatelessWidget {
  const NpcDisplayHeader({
    super.key,
  });

  String npcMessage(TradeState state) {
    if (state.step == TradingStep.selectOfferType) {
      final resourceName = state.selectedResource?.tradeResource.name ?? '';
      return 'Dunque sei interessato a scambiare $resourceName con me?. bene, allora scegli se vuoi comprare o vendere';
    } else if (state.step == TradingStep.setPrice) {
      return 'Imposta il prezzo per la tua offerta:';
    }
    return 'Sarebbe comodo se potessi vendermi le risorse segnate in rosso. Scegli una risorsa che vuoi scambiare con me.';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<TradeBloc, TradeState>(
      buildWhen: (previous, current) =>
          (previous.npc != current.npc) || (previous.step != current.step),
      builder: (context, state) {
        return Stack(
          children: [
            Row(
              children: [
                Image.asset(
                  AppImages.rosario,
                  height: 230,
                ),
                Expanded(
                  child: SizedBox(
                    height: 230,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LabelText(
                              l10n.tradeNpcWealth(state.npc?.name ?? 'NPC')),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LabelText(
                                state.npc?.wealth.toString() ?? '0',
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
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: NpcDialogueBox(
                speaker: state.npc?.name ?? '',
                text: npcMessage(state),
              ),
            ),
          ],
        );
      },
    );
  }
}
