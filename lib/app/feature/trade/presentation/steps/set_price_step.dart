import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_event.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/trade_resource_element.dart';
import 'package:valli_di_comacchio/app/shared/components/appButton/glowing_button.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/components/text_field/app_textfield.dart';
import 'package:valli_di_comacchio/app/shared/components/text_field/app_textfield_style.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';

class SetPriceStep extends StatelessWidget {
  const SetPriceStep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradeBloc, TradeState>(
      builder: (context, state) {
        return Expanded(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // NPC Offer
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      Center(child: LabelText('Price')),
                      Center(child: LabelText('Quantity')),
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: LabelText('Total'),
                      )),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppIcons.money,
                              width: 28,
                              height: 28,
                              colorFilter: const ColorFilter.mode(
                                AppColors.palette_primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 4),
                            H3(state.npcOffert!.offerPrice.toString()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TradeResourceElement(
                                resource:
                                    state.npcOffert!.tradeResourceInventory),
                            const SizedBox(width: 4),
                            H3('x${state.npcOffert!.offerQuantity}'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            H3('='),
                            const SizedBox(width: 4),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.money,
                                  width: 28,
                                  height: 28,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.palette_primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                H3('${state.npcOffert!.offerPrice}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GlowingButton(
                        text: 'ACCETTA',
                        onPressed: () {
                          context.read<TradeBloc>().add(AcceptOffer());
                        }),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // User Counter Offer
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      Center(child: LabelText('Price')),
                      Center(child: LabelText('Quantity')),
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: LabelText('Total'),
                      )),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppIcons.money,
                              width: 28,
                              height: 28,
                              colorFilter: const ColorFilter.mode(
                                AppColors.palette_primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 4),
                            H3(state.npcOffert!.offerPrice.toString()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TradeResourceElement(
                                resource:
                                    state.npcOffert!.tradeResourceInventory),
                            const SizedBox(width: 4),
                            H3('x${state.npcOffert!.offerQuantity}'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            H3('='),
                            const SizedBox(width: 4),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.money,
                                  width: 28,
                                  height: 28,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.palette_primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                H3('${state.npcOffert!.offerPrice}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppTextField(
                type: AppTextFieldType.number,
                onChange: (value) {},
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       GlowingButton(
              //           text: 'ACCETTA',
              //           onPressed: () {
              //             context.read<TradeBloc>().add(AcceptOffer());
              //           }),
              //     ],
              //   ),
              // ),
            ],
          ),
        ));
      },
    );
  }
}
