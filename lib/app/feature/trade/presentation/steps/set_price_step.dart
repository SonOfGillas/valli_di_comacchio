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
import 'package:valli_di_comacchio/app/shared/components/debounce_text_field/debounce_text_field.dart';
import 'package:valli_di_comacchio/app/shared/components/text_field/app_textfield.dart';
import 'package:valli_di_comacchio/app/shared/components/text_field/app_textfield_style.dart';
import 'package:valli_di_comacchio/app/shared/domain/utils/number_formatter.dart';
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
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                            H3(formatNumber(state.npcOffert!.offerPrice)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TradeResourceElement(
                              resource: state.npcOffert!.tradeResourceInventory,
                              size: TradeResourceElmentSize.small,
                            ),
                            const SizedBox(width: 4),
                            H3('x${formatNumber(state.npcOffert!.offerQuantity)}'),
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
                                H3(formatNumber(state.npcOffert!.totalCost)),
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
              SizedBox(height: 24),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: DebouncedTextField(
                                onDebouncedChange: (value) {
                                  context.read<TradeBloc>().add(
                                        SetCounterOfferPrice(
                                          price: int.tryParse(value) ?? 0,
                                        ),
                                      );
                                },
                                textField: AppTextField(
                                  errorMessage: state.isCounterOfferValid
                                      ? null
                                      : 'non valido',
                                  placeHolder:
                                      '${state.userCounterOffert?.offerPrice}',
                                  type: AppTextFieldType.number,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          height: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: TradeResourceElement(
                                  resource:
                                      state.npcOffert!.tradeResourceInventory,
                                  size: TradeResourceElmentSize.small,
                                ),
                              ),
                              H3('x'),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: DebouncedTextField(
                                  onDebouncedChange: (value) {
                                    context.read<TradeBloc>().add(
                                          SetCounterOfferQuantity(
                                            quantity: int.tryParse(value) ?? 0,
                                          ),
                                        );
                                  },
                                  textField: AppTextField(
                                    errorMessage: state.isCounterOfferValid
                                        ? null
                                        : 'non valido',
                                    placeHolder:
                                        '${state.userCounterOffert?.offerQuantity}',
                                    type: AppTextFieldType.number,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                H3('${state.userCounterOffert?.totalCost}'),
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppTextField(
                  placeHolder: 'inserisci un messaggio per ${state.npc?.name}',
                  type: state.messageToTheNpc.length < 40
                      ? AppTextFieldType.text
                      : AppTextFieldType.textArea,
                  onChange: (value) {
                    context.read<TradeBloc>().add(
                          SetCounterOfferMessage(message: value),
                        );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GlowingButton(
                        text: 'CONTROFFERTA',
                        onPressed: () {
                          context.read<TradeBloc>().add(SendCounterOffer());
                        }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
