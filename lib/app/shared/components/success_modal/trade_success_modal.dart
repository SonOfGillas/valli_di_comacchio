import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_resource_offer.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/trade_resource_element.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h1_on_primary/h1_on_primary.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/components/success_modal/base_success_modal.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/offer_type.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

class TradeSuccessModal extends StatelessWidget {
  const TradeSuccessModal(
      {super.key,
      required this.npc,
      required this.offer,
      required this.onClose});

  final Npc npc;
  final TradeResourceOffer offer;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return BaseSuccessModal(
        onClose: onClose,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const H1('Trade Successful!'),
            const SizedBox(height: 16),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    TradeResourceElement(
                      resource: offer.tradeResourceInventory,
                      size: TradeResourceElmentSize.medium,
                      isUserResource: offer.offerType == OfferType.sell,
                    ),
                    (offer.offerType == OfferType.buy)
                        ? Image.asset(
                            AppImages.rosario,
                            height: 80,
                          )
                        : const Icon(Icons.person,
                            size: 80, color: AppColors.palette_primary),
                  ],
                ),
                TableRow(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_downward,
                            size: 40, color: AppColors.palette_primary),
                        LabelText('+${offer.offerQuantity}',
                            withBoarder: false),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LabelText('+${offer.totalCost}',
                                withBoarder: false),
                            const SizedBox(width: 4),
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
                        ),
                        const Icon(Icons.arrow_upward,
                            size: 40, color: AppColors.palette_primary),
                      ],
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TradeResourceElement(
                      resource: offer.tradeResourceInventory,
                      size: TradeResourceElmentSize.medium,
                      isUserResource: offer.offerType == OfferType.buy,
                    ),
                    (offer.offerType == OfferType.sell)
                        ? Image.asset(
                            AppImages.rosario,
                            height: 80,
                          )
                        : const Icon(Icons.person,
                            size: 80, color: AppColors.palette_primary),
                  ],
                ),
              ],
            )
          ],
        ));
  }
}
