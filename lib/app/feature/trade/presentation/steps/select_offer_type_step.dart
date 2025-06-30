import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_event.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/demand_info_gradient.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/trade_resource_element.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/components/appButton/glowing_button.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/offer_type.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

class SelectOfferTypeStep extends StatelessWidget {
  const SelectOfferTypeStep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradeBloc, TradeState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: DemandInfoGradient(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      H3('${state.npc?.name} possiede:'),
                      TradeResourceElement(
                          resource: state.selectedResource!,
                          size: TradeResourceElmentSize.large),
                      if (state.npc?.imageLocalPath != null)
                        Image.asset(
                          state.npc!.imageLocalPath,
                          height: 80,
                        ),
                    ],
                  ),
                  Builder(builder: (context) {
                    return BlocBuilder<AppCubit, AppState>(
                      builder: (context, appState) {
                        final userResource =
                            appState.user?.inventory.firstWhere(
                          (element) =>
                              element.tradeResource ==
                              state.selectedResource!.tradeResource,
                        );
                        return Column(
                          children: [
                            H3('Tu possiedi:'),
                            if (userResource != null)
                              TradeResourceElement(
                                  resource: userResource,
                                  isUserResource: true,
                                  size: TradeResourceElmentSize.large),
                            // Account Icon
                            const Icon(Icons.person,
                                size: 80, color: AppColors.palette_primary),
                          ],
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  Expanded(
                    child: GlowingButton(
                        text: 'COMPRA',
                        onPressed: () {
                          context
                              .read<TradeBloc>()
                              .add(SelectOfferType(offerType: OfferType.buy));
                        }),
                  ),
                  SizedBox(width: 32),
                  Expanded(
                    child: GlowingButton(
                        text: 'VENDI',
                        onPressed: () {
                          context
                              .read<TradeBloc>()
                              .add(SelectOfferType(offerType: OfferType.sell));
                        }),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
