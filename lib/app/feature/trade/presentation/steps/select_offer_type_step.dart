import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/domain/entities/trade_resource_offer.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_bloc.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_event.dart';
import 'package:valli_di_comacchio/app/feature/trade/logic/trade_state.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/demand_info_gradient.dart';
import 'package:valli_di_comacchio/app/feature/trade/presentation/components/trade_resource_element.dart';
import 'package:valli_di_comacchio/app/shared/components/appButton/glowing_button.dart';
import 'package:valli_di_comacchio/app/shared/components/appButton/retro_gold_button.dart';

class SelectOfferTypeStep extends StatelessWidget {
  const SelectOfferTypeStep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradeBloc, TradeState>(
      builder: (context, state) {
        return Expanded(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: DemandInfoGradient(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //H3('${state.npc?.name} possiede:'),
                    TradeResourceElement(
                        resource: state.selectedResource!, expanded: true),
                    //H3('x ${state.selectedResource!.storage}'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
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
        ));
      },
    );
  }
}
